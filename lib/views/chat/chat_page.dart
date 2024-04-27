import 'dart:async';
import 'package:aibridge/views/common/appbars/normal_app_bar.dart';
import 'package:aibridge/views/chat/widgets/chat_input.dart';
import 'package:aibridge/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';

import '../../widgets/widgets.dart';
import '../../utils/utils.dart';
import '../../models/models.dart';
import '../../constants/constants.dart';
import '../../providers/providers.dart';
import '../views.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.arguments}) : super(key: key);

  final ChatPageArguments arguments;

  @override
  ChatPageState createState() => ChatPageState();
}

enum ChatPageMode{
  chatMode,
  editMode,
  deleteMode
}

class ChatPageState extends State<ChatPage> with WidgetsBindingObserver{

  // State variables
  ChatPageMode mode = ChatPageMode.chatMode;
  bool _isLoading = true;
  bool _isInputMenuVisible = false;
  bool _isSendEnabled = true;
  ChatMessage _messageToEdit = ChatMessage.placeHolder();
  final ValueNotifier<List<ChatMessage>> _messagesToDeleteNotifier =
  ValueNotifier<List<ChatMessage>>([]);

  // Controllers
  final TextEditingController _inputTextEditingController = TextEditingController();
  final TextEditingController _chatTextEditingController = TextEditingController();
  final TextEditingController _imageURLTextEditingController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();

  // FocusNodes
  final FocusNode _inputFocusNode = FocusNode();
  final FocusNode _editCharacterChatFocusNode = FocusNode();
  final FocusNode _editUserChatFocusNode = FocusNode();

  // Providers
  late ThemeProvider themeProvider;
  late ChatProvider chatProvider;
  late CharactersProvider charactersProvider;
  late ChatRoomsProvider chatRoomsProvider;

  // Keyboard Height Listener
  StreamSubscription? _onKeyboardVisibilityChangeSub;

  @override
  void initState() {
    super.initState();
    themeProvider = context.read<ThemeProvider>();
    chatProvider = context.read<ChatProvider>();
    charactersProvider = context.read<CharactersProvider>();
    chatRoomsProvider = context.read<ChatRoomsProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = context.watch<ThemeProvider>();
    charactersProvider = context.watch<CharactersProvider>();
    return Selector<ChatRoomsProvider, ChatRoomSetting>(
      selector: (_, provider) => provider.chatRoomSetting!,
      builder: (context, settings, _) {
        return PopScope(
          onPopInvoked: (didPop) => _onBackPress,
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: NormalAppBar(
                title: mode == ChatPageMode.editMode ? Intl.message("editChatOption") :
                mode == ChatPageMode.deleteMode ? Intl.message("deleteOption") :
                charactersProvider.currentCharacter.characterName,
                enableBackButton: true
              ),
              body: Stack(
                children: [
                  Positioned(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //List of messages
                        Expanded(
                            child: Container(
                              color: settings.chatRoomBackgroundColor,
                              child: Consumer<ChatProvider>(
                                builder: (context, chatProvider, _) { // reverse solution: //solution from https://stackoverflow.com/questions/70577942/flutter-resizetoavoidbottominset-true-not-working-with-expanded-listview
                                  final chatMessages = chatProvider.chatMessages;
                                  return Align(
                                        alignment: Alignment.topCenter,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          reverse: true,
                                          cacheExtent: _isLoading? double.maxFinite: null, // without this, scrollChatToBottom() at first does not work
                                          padding: const EdgeInsets.only(top: 10),
                                          controller: _chatScrollController,
                                          itemCount: chatMessages.length + 1,
                                          itemBuilder: (context, index) => _buildItem(
                                              index,
                                              chatMessages.reversed.toList(),
                                              chatProvider.requestState,
                                              settings
                                          ),
                                        ),
                                      );
                                },
                              ),
                            )
                        ),
                        //Input content
                        if (mode == ChatPageMode.editMode) ...[
                          EditBar(onPressed: () => _onEditChat()),
                        ] else if (mode == ChatPageMode.deleteMode) ...[
                          DeleteBar(onPressed: () => _onDeleteChat()),
                        ] else ...[
                          ChatInputField(
                            controller: _inputTextEditingController,
                            focusNode: _inputFocusNode,
                            isSendEnabled: _isSendEnabled,
                            isMenuVisible: _isInputMenuVisible,
                            onMenuOpen: () => _onMenuOpen(),
                            onSendChat: () => _onSubmitInput(),
                          ),
                          _isInputMenuVisible
                          ? ChatMenu(
                            menuHeight: chatProvider.getKeyboardHeight(context),
                            menuItems: getChatMenus(),
                          )
                          : const SizedBox.shrink(),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                      child: _isLoading ? const LoadingView() : const SizedBox.shrink()
                  ),
                ],
              )
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    //dispose controller
    _inputTextEditingController.dispose();
    _chatTextEditingController.dispose();
    _onKeyboardVisibilityChangeSub?.cancel();
    _chatScrollController.dispose();
    //dispose focus node
    _inputFocusNode.dispose();
    _editCharacterChatFocusNode.dispose();
    _editUserChatFocusNode.dispose();
    // Dispose ValueNotifiers
    _messagesToDeleteNotifier.dispose();
    chatProvider.removeListener(_onNetworkStateChanged);
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> _init() async {
    final backgroundColor = Theme.of(context).colorScheme.background;
    await chatRoomsProvider.readChatRoomSetting(backgroundColor);
    await charactersProvider.updateCurrentCharacter(widget.arguments.characterId);
    await chatRoomsProvider.updateCurrentChatRoom(widget.arguments.characterId);

    await chatProvider.updateChatMessages(chatRoomsProvider.currentChatRoom.id!);

    chatProvider.setRequestState(RequestState.initialized);
    chatProvider.addListener(_onNetworkStateChanged);
    _onKeyboardVisibilityChangeSub = _observeKeyboardHeight(_keyboardVisibilityController);
    _inputFocusNode.addListener(() {
      if (_inputFocusNode.hasFocus) {
        setState(() => _isInputMenuVisible = false);
      }
    });

    await Future.delayed(const Duration(milliseconds: 30), _scrollChatToBottom);

    setState(() => _isLoading = false);
  }

  StreamSubscription? _observeKeyboardHeight(KeyboardVisibilityController controller){
    return controller.onChange.listen((bool isVisible) async {
      if (isVisible) {
        await Future.delayed(const Duration(milliseconds: 500));
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        if(keyboardHeight >= chatProvider.getKeyboardHeight(context)){
          chatProvider.setKeyboardHeight(keyboardHeight);
        }
      }
    });
  }

  void _scrollChatToBottom() {
    if(_chatScrollController.hasClients && mounted){
      _chatScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildItem(
      int index,
      List<ChatMessage> chatMessages,
      RequestState requestState,
      ChatRoomSetting settings
  ){
    /*
    * NOTE : Last item should be a placeholder for the typing indicator.
    * Since the list view is reversed, there is a placeholder for index 0. (index 0 is the last item, since the list view is reversed)
    * */
    final items = [ChatMessage.placeHolder(), ...chatMessages];
    final content = items[index];

    if (index == 0 && requestState == RequestState.loading) {
      return CharacterMessageLoading(
        chatMessage: content,
        chatTextEditingController: _chatTextEditingController,
        editChatFocusNode: _editCharacterChatFocusNode,
        mode: ChatPageMode.chatMode,
        settings: settings,
        themeProvider: themeProvider,
        charactersProvider: charactersProvider,
      );
    }

    if (content.chatMessageType == ChatMessageType.userMessage) {
      if(mode==ChatPageMode.deleteMode){
        return UserMessageDeleteMode(
            chatMessage: content,
            settings: settings,
            mode: mode,
            messagesToDeleteNotifier: _messagesToDeleteNotifier,
            chatTextEditingController: _chatTextEditingController,
            editChatFocusNode: _editUserChatFocusNode,
            themeProvider: themeProvider
        );
      }
      return UserMessage(
          chatMessage: content,
          settings: settings,
          mode: mode,
          chatTextEditingController: _chatTextEditingController,
          editChatFocusNode: _editUserChatFocusNode,
          dialogCallback: () => _openChatDialog(content),
          themeProvider: themeProvider
      );
    }

    if (content.chatMessageType == ChatMessageType.characterMessage){
      if(mode==ChatPageMode.deleteMode){
        return CharacterMessageDeleteMode(
            chatMessage: content,
            settings: settings,
            mode: mode,
            messagesToDeleteNotifier: _messagesToDeleteNotifier,
            chatTextEditingController: _chatTextEditingController,
            editChatFocusNode: _editUserChatFocusNode,
            themeProvider: themeProvider,
            charactersProvider: charactersProvider,
        );
      }

      return CharacterMessage(
          chatMessage: content,
          settings: settings,
          mode: mode,
          chatTextEditingController: _chatTextEditingController,
          editChatFocusNode: _editUserChatFocusNode,
          dialogCallback: () => _openChatDialog(content),
          profileCallback: () async => {
            _navigateTo(
              CharacterProfilePage(
                arguments: CharacterProfilePageArguments(
                  characterId: charactersProvider.currentCharacter.id!,
                  fromChatPage: true
                )
              )
            )
          },
          themeProvider: themeProvider,
          charactersProvider: charactersProvider,
      );
    }
    return const SizedBox.shrink();
  }

  Future<bool> _onBackPress() async {
    switch(mode){
      case ChatPageMode.deleteMode:
        _messagesToDeleteNotifier.value = [];
        break;
      case ChatPageMode.editMode:
        _editCharacterChatFocusNode.unfocus();
        _editUserChatFocusNode.unfocus();
        chatProvider.updateOneChatMessage(_messageToEdit.copyWith(isEditable: false));
        _messageToEdit = ChatMessage.placeHolder();
        _chatTextEditingController.text = "";
        break;
      case ChatPageMode.chatMode:
        if (_isInputMenuVisible) {
          setState(() => _isInputMenuVisible = false);
          break;
        }
        Navigator.pop(context);
        break;
    }

    setState(() => mode = ChatPageMode.chatMode);
    return Future.value(false);
  }

  Future<void> _openPasteDialog() async {
    final result = await showDialog(
        context: context,
        builder: (context) => TextPaster(
            title: Intl.message("uploadImage"),
            subTitle: Intl.message("gpt4VisionOnly"),
            labelText: Intl.message("pasteImageURL"),
            buttonText: Intl.message("upload"),
            textFieldController: _imageURLTextEditingController
        ),
    );

    switch (result){
      case DialogResult.yes:
        final character = charactersProvider.currentCharacter;
        final imageInput = ChatMessage(
            roomId: chatRoomsProvider.currentChatRoom.id!,
            characterId: character.id!,
            chatMessageType: ChatMessageType.userMessage,
            timestamp: Utilities.getTimestamp(),
            role: "user",
            content: _imageURLTextEditingController.text,
            imageUrl: _imageURLTextEditingController.text
        );
        await chatProvider.insertChatMessage(imageInput);
        _imageURLTextEditingController.text = "";

        await _handleSendChatEvent(character);
    }
  }

  Future<void> _handleSendChatEvent(Character character) async {
    switch(character.service.serviceType){
      case ServiceType.openAI:
        final service = character.service as OpenAIService;
        await chatProvider.openAIStreamCompletion(
          service,
          chatProvider.chatMessages,
          chatRoomsProvider.currentChatRoom.id!,
          character,
        );

      case ServiceType.paLM:
        final service = character.service as PaLMService;
        await chatProvider.paLMChatCompletion(
          service,
          chatProvider.chatMessages,
          chatRoomsProvider.currentChatRoom.id!,
          character,
        );
    }
  }

  Future<void> _openChatDialog(ChatMessage chatMessage) async {
    final result = await showDialog(
        context: context,
        builder: (context) => const ChatOption()
    );

    switch(result){
      case DialogResult.edit:
        chatMessage.isEditable = true;
        _chatTextEditingController.text = chatMessage.content;
        _inputFocusNode.requestFocus();
        setState(() {
          _messageToEdit = chatMessage;
          mode = ChatPageMode.editMode;
        });

      case DialogResult.delete :
        setState(() {
          mode = ChatPageMode.deleteMode;
        });

      case DialogResult.copy :
        await Clipboard.setData(ClipboardData(text: chatMessage.content));
    }
  }

  Future<void> _openMovePageDialog(String title, String message) async {
    final result = await showDialog(
        context: context,
        builder: (context) => WarningDialog(
            icon: Icons.key,
            title: title,
            message: message
        ),
    );

    switch(result){
      case DialogResult.cancel:
        chatProvider.setRequestState(RequestState.initialized);
        break;
      case DialogResult.yes:
        chatProvider.setRequestState(RequestState.initialized);
        _navigateTo(const MainNavigationPage(initialIndex: 0));
        break;
      case null: // when dialog is dismissed by tab somewhere else
        chatProvider.setRequestState(RequestState.initialized);
    }
  }

  Future<void> _onMenuOpen() async {
    if(_keyboardVisibilityController.isVisible){
      _inputFocusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _isInputMenuVisible = true;
      });
    } else{
      setState(() {
        _inputFocusNode.unfocus();
        _isInputMenuVisible = !_isInputMenuVisible;
      });
    }
  }

  Future<void> _onDeleteChat() async {
    await chatProvider.deleteChatMessages(_messagesToDeleteNotifier.value, chatRoomsProvider.currentChatRoom.id!);
    await chatRoomsProvider.updateChatRooms();
    setState(() {
      mode=ChatPageMode.chatMode;
      _messagesToDeleteNotifier.value = [];
    });
  }

  Future<void> _onEditChat() async {
    final editedChatMessage = _messageToEdit.copyWith(
      content: _chatTextEditingController.text,
      isEditable: false
    );

    await chatProvider.updateOneChatMessage(editedChatMessage);
    await chatRoomsProvider.updateChatRooms();
    setState(() {
      _messageToEdit = ChatMessage.placeHolder();
      mode = ChatPageMode.chatMode;
      _chatTextEditingController.text = "";
    });
  }

  List<ChatMenuItem> getChatMenus(){
    return [
      ChatMenuItem(
        icon: Icons.edit,
        label: Intl.message("editProfile"),
        onPressed: () => {
          _navigateTo(CharacterCreationPage(
            arguments: CharacterCreationPageArguments(
                character: charactersProvider.currentCharacter
            ),
          ))
      }),
      ChatMenuItem(
        icon: Icons.settings,
        label: Intl.message("chatRoomSetting"),
        onPressed: () => {
          _navigateTo(const ChatRoomSettingPage())
      }),
      ChatMenuItem(
        icon: Icons.image,
        label: Intl.message("image"),
        onPressed: () => {
          if (context.mounted){
            _openPasteDialog()
          }
      })
    ];
  }

  void _navigateTo(StatefulWidget page){
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        )
      );
    }
  }

  Future<void> _onSubmitInput() async {
    final currentChatRoom = chatRoomsProvider.currentChatRoom;
    final character = charactersProvider.currentCharacter;

    final now = Utilities.getTimestamp();
    final inputChatMessage = ChatMessage(
      roomId: currentChatRoom.id!,
      characterId: character.id!,
      chatMessageType: ChatMessageType.userMessage,
      timestamp: now,
      role: "user",
      content: _inputTextEditingController.text,
    );

    await chatProvider.insertChatMessage(inputChatMessage);
    _inputTextEditingController.text = "";
    _scrollChatToBottom();

    await _handleSendChatEvent(character);
  }

  void _onNetworkStateChanged(){
    switch(chatProvider.requestState){
      case RequestState.invalidOpenAIAPIKey:
        _openMovePageDialog(Intl.message("chatGPTAPIKeyErrorTitle"), Intl.message("chatGPTAPIisInvalid"));
      case RequestState.invalidPaLMAPIKey:
        _openMovePageDialog(Intl.message("paLMAPIKeyErrorTitle"), Intl.message("paLMAPIisInvalid"));
      case RequestState.loading:
      case RequestState.answering:
        setState(() {
          _isSendEnabled = false;
        });
      case RequestState.initialized:
      case RequestState.done:
        setState(() {
          _isSendEnabled = true;
        });
    }
  }

}


class ChatPageArguments {
  final String characterId;

  ChatPageArguments({required this.characterId});
}