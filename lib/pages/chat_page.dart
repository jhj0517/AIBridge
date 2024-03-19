import 'dart:async';
import 'package:aibridge/widgets/chat_input.dart';
import 'package:aibridge/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';

import '../widgets/widgets.dart';
import '../utils/utils.dart';
import '../models/models.dart';
import '../constants/constants.dart';
import '../providers/providers.dart';
import 'pages.dart';

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

  bool _isLoading = true;

  bool _isInputMenuVisible = false;
  ChatPageMode mode = ChatPageMode.chatMode;

  bool _isSendEnabled = true;
  ChatMessage _messageToEdit = ChatMessage.placeHolder();
  final ValueNotifier<List<ChatMessage>> _messagesToDeleteNotifier = ValueNotifier<List<ChatMessage>>([]);

  final KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();
  StreamSubscription? _onKeyboardVisibilityChangeSub;
  final TextEditingController _inputTextEditingController = TextEditingController();
  final TextEditingController _chatTextEditingController = TextEditingController();
  final TextEditingController _imageURLTextEditingController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  final FocusNode _editCharacterChatFocusNode = FocusNode();
  final FocusNode _editUserChatFocusNode = FocusNode();

  late ThemeProvider themeProvider;
  late ChatProvider chatProvider;
  late CharactersProvider charactersProvider;
  late ChatRoomsProvider chatRoomsProvider;

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
    charactersProvider = context.watch<CharactersProvider>(); // makes new instance of the page whenever character is updated
    return Selector<ChatRoomsProvider, ChatRoomSetting>(
      selector: (_, provider) => provider.chatRoomSetting!,
      builder: (context, settings, _) {
        return PopScope(
          onPopInvoked: (didPop) => _onBackPress,
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Text(
                  mode == ChatPageMode.editMode ? Intl.message("editChatOption") :
                  mode == ChatPageMode.deleteMode ? Intl.message("deleteOption") :
                  charactersProvider.currentCharacter.characterName,
                  style: const TextStyle(color: ColorConstants.appbarTextColor),
                ),
                backgroundColor: themeProvider.attrs.appbarColor,
                centerTitle: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.white,
                  onPressed: () async {
                    await _onBackPress();
                  },
                ),
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
    chatProvider.removeListener(_networkStateListenerFunction);
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> _init() async {
    // init ChatRoomSetting
    await chatRoomsProvider.readChatRoomSetting(themeProvider.attrs.backgroundColor);
    // init Request state and add Listener
    chatProvider.setRequestState(RequestState.initialized);
    chatProvider.addListener(() {
      _networkStateListenerFunction();
    });
    // init Keyboard height listener to scroll down chat list when keyboard appears
    _onKeyboardVisibilityChangeSub = _applyKeyboardHeightListener(_keyboardVisibilityController);
    // init Input focus node to deal with focus when Long-Press touch happens
    _inputFocusNode.addListener(() {
      if (_inputFocusNode.hasFocus){
        setState(() {
          _isInputMenuVisible = false;
        });
      }
    });

    await charactersProvider.updateCurrentCharacter(widget.arguments.characterId);
    await chatRoomsProvider.updateCurrentChatRoom(widget.arguments.characterId);
    await chatProvider.updateChatMessages(chatRoomsProvider.currentChatRoom.id!);

    // scroll down to bottom of the chat list when user visit page first.
    await Future.delayed(const Duration(milliseconds: 30), () {
      _scrollChatToBottom();
    });
    // set isLoading false
    setState(() {
      _isLoading = false;
    });
  }

  StreamSubscription? _applyKeyboardHeightListener(KeyboardVisibilityController controller){
    return controller.onChange.listen((bool isVisible) async {
      if (isVisible) {
        // Scroll Down by Keyboard Height when keyboard is appeared
        // I have to do this because of this issue https://github.com/flutter/flutter/issues/96279
        await Future.delayed(const Duration(milliseconds: 500));
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        if(keyboardHeight != chatProvider.getKeyboardHeight(context) && keyboardHeight>0){
          //save Keyboard Height to SharedPreference
          await chatProvider.setKeyboardHeight(keyboardHeight);
        }
      } else {
        //Scroll up by keyboard height when keyboard is disappeared
        _inputFocusNode.unfocus();
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
      return CharacterChatBoxLoading(
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
        return UserChatBoxDeleteMode(
            chatMessage: content,
            settings: settings,
            mode: mode,
            messagesToDeleteNotifier: _messagesToDeleteNotifier,
            chatTextEditingController: _chatTextEditingController,
            editChatFocusNode: _editUserChatFocusNode,
            themeProvider: themeProvider
        );
      }
      return UserChatBox(
          chatMessage: content,
          settings: settings,
          mode: mode,
          chatTextEditingController: _chatTextEditingController,
          editChatFocusNode: _editUserChatFocusNode,
          dialogCallback: () => _openChatDialog(context, content),
          themeProvider: themeProvider
      );
    }

    if (content.chatMessageType == ChatMessageType.characterMessage){
      if(mode==ChatPageMode.deleteMode){
        return CharacterChatBoxDeleteMode(
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

      return CharacterChatBox(
          chatMessage: content,
          settings: settings,
          mode: mode,
          chatTextEditingController: _chatTextEditingController,
          editChatFocusNode: _editUserChatFocusNode,
          dialogCallback: () => _openChatDialog(context, content),
          themeProvider: themeProvider,
          charactersProvider: charactersProvider,
      );
    }
    return const SizedBox.shrink();
  }

  Future<bool> _onBackPress() async {
    if(mode == ChatPageMode.deleteMode){
      _messagesToDeleteNotifier.value = [];
      setState(() {
        mode = ChatPageMode.chatMode;
      });
    }else if(mode == ChatPageMode.editMode){
      if(_editCharacterChatFocusNode.hasFocus || _editUserChatFocusNode.hasFocus){
        _editCharacterChatFocusNode.unfocus();
        _editUserChatFocusNode.unfocus();
      }
      final editedChatMessage = ChatMessage(
        id: _messageToEdit.id,
        roomId: _messageToEdit.roomId,
        characterId: _messageToEdit.characterId,
        chatMessageType: _messageToEdit.chatMessageType,
        timestamp: _messageToEdit.timestamp,
        role: _messageToEdit.role,
        content: _messageToEdit.content,
        isEditable: false,
      );
      chatProvider.updateOneChatMessage(editedChatMessage);
      _messageToEdit = ChatMessage.placeHolder();
      _chatTextEditingController.text = "";
      setState(() {
        mode = ChatPageMode.chatMode;
      });
    } else if(_isInputMenuVisible){
      setState(() {
        _isInputMenuVisible=false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  Future<void> _openPasteDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return TextPaster(
              title: Intl.message("uploadImage"),
              subTitle: Intl.message("gpt4VisionOnly"),
              labelText: Intl.message("pasteImageURL"),
              buttonText: Intl.message("upload"),
              textFieldController: _imageURLTextEditingController
          );
        })) {
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
        if(character.service.serviceType == ServiceType.openAI){
          final service = character.service as OpenAIService;
          await chatProvider.openAIStreamCompletion(
            service,
            chatProvider.chatMessages,
            chatRoomsProvider.currentChatRoom.id!,
            character,
          );
        } else if (character.service.serviceType == ServiceType.paLM){
          final service = character.service as PaLMService;
          await chatProvider.paLMChatCompletion(
            service,
            chatProvider.chatMessages,
            chatRoomsProvider.currentChatRoom.id!,
            character,
          );
        }
        break;
    }
  }

  Future<void> _openChatDialog(BuildContext context, ChatMessage chatMessage) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ChatOption();
        })) {
      case DialogResult.edit:
        _chatTextEditingController.text = chatMessage.content;
        final editableChatMessage = ChatMessage(
          id: chatMessage.id,
          roomId: chatMessage.roomId,
          characterId: chatMessage.characterId,
          chatMessageType: chatMessage.chatMessageType,
          timestamp: chatMessage.timestamp,
          role: chatMessage.role,
          content: chatMessage.content,
          isEditable: true,
        );
        await chatProvider.updateOneChatMessage(editableChatMessage);
        _inputFocusNode.requestFocus();
        setState(() {
          _messageToEdit = editableChatMessage;
          mode = ChatPageMode.editMode;
        });
        break;
      case DialogResult.delete :
        setState(() {
          mode = ChatPageMode.deleteMode;
        });
        break;
      case DialogResult.copy :
        await Clipboard.setData(ClipboardData(text: chatMessage.content));
        break;
    }
  }

  Future<void> _openMovePageDialog(String title, String message) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(icon: Icons.key, title: title, message: message);
        })) {
      case DialogResult.cancel:
        chatProvider.setRequestState(RequestState.initialized);
        break;
      case DialogResult.yes:
        chatProvider.setRequestState(RequestState.initialized);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MainNavigationPage(initialIndex: 0)));
        break;
      case null: // when dialog is dismissed by tab somewhere else
        chatProvider.setRequestState(RequestState.initialized);
        break;
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
    final editedChatMessage = ChatMessage(
      id: _messageToEdit.id,
      roomId: _messageToEdit.roomId,
      characterId: _messageToEdit.characterId,
      chatMessageType: _messageToEdit.chatMessageType,
      timestamp: _messageToEdit.timestamp,
      role: _messageToEdit.role,
      content: _chatTextEditingController.text,
      isEditable: false,
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
          navigateTo(CharacterCreationPage(
            arguments: CharacterCreationPageArguments(
                character: charactersProvider.currentCharacter
            ),
          ))
      }),
      ChatMenuItem(
        icon: Icons.settings,
        label: Intl.message("chatRoomSetting"),
        onPressed: () => {
          navigateTo(const ChatRoomSettingPage())
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

  void navigateTo(StatefulWidget page){
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page, // This should be variable
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
    _scrollChatToBottom();
    _inputTextEditingController.text = "";

    switch (character.service.serviceType) {
      case ServiceType.openAI:
        final openAIService = character.service as OpenAIService;
        await chatProvider.openAIStreamCompletion(
          openAIService,
          chatProvider.chatMessages,
          currentChatRoom.id!,
          character,
        );
        break;
      case ServiceType.paLM:
        final paLMService = character.service as PaLMService;
        await chatProvider.paLMChatCompletion(
          paLMService,
          chatProvider.chatMessages,
          currentChatRoom.id!,
          character,
        );
        break;
      default:
      // Handle unsupported service types (optional)
    }
  }

  void _networkStateListenerFunction(){
    switch(chatProvider.requestState){
      case RequestState.invalidOpenAIAPIKey:
        _openMovePageDialog(Intl.message("chatGPTAPIKeyErrorTitle"), Intl.message("chatGPTAPIisInvalid"));
        break;
      case RequestState.invalidPaLMAPIKey:
        _openMovePageDialog(Intl.message("paLMAPIKeyErrorTitle"), Intl.message("paLMAPIisInvalid"));
        break;
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
        break;
    }
  }

}


class ChatPageArguments {
  final String characterId;

  ChatPageArguments({required this.characterId});
}