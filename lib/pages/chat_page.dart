import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
  bool _isInputEmpty = true;
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
                          _buildEditInput(), //Positioned bottom: MediaQuery.of(context).viewInsets.bottom,
                        ] else if (mode == ChatPageMode.deleteMode) ...[
                          _buildDeleteInput(),
                        ] else ...[
                          _buildInput(),
                          _isInputMenuVisible
                          ? _buildInputMenu()
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
    _inputFocusNode.addListener(_onFocusChange);
    _inputTextEditingController.addListener(() {
      setState(() {
        _isInputEmpty = _inputTextEditingController.text.isEmpty;
      });
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
          return Dialogs.pasteTextDialog(
            context,
            Intl.message("uploadImage"),
            Intl.message("gpt4VisionOnly"),
            Intl.message("pasteImageURL"),
            Intl.message("upload"),
            _imageURLTextEditingController,
          );
        })) {
      case OnPasteDialogOptionClicked.onOKButton:
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
          debugPrint("currentMessages : ${chatProvider.chatMessages}");
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
      case null: // when dialog is dismissed by tab somewhere else
        break;
    }
  }

  Future<void> _openChatDialog(BuildContext context, ChatMessage chatMessage) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialogs.chatDialog(context);
        })) {
      case OnChatOptionClicked.onEdit:
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
      case OnChatOptionClicked.onDelete :
        setState(() {
          mode = ChatPageMode.deleteMode;
        });
        break;
      case OnChatOptionClicked.onCopy :
        await Clipboard.setData(ClipboardData(text: chatMessage.content));
        break;
    }
  }

  Future<void> _openMovePageDialog(String title, String message) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialogs.yesOrNoDialog(
            context,
            Icons.key,
            title,
            message,
          );
        })) {
      case OnYesOrNoOptionClicked.onCancel:
        chatProvider.setRequestState(RequestState.initialized);
        break;
      case OnYesOrNoOptionClicked.onYes:
        chatProvider.setRequestState(RequestState.initialized);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MainNavigationPage(initialIndex: 0)));
        break;
      case null: // when dialog is dismissed by tab somewhere else
        chatProvider.setRequestState(RequestState.initialized);
        break;
    }
  }

  void _onFocusChange() {
    if (_inputFocusNode.hasFocus){
      // Hide menu when keyboard appear
      setState(() {
        _isInputMenuVisible = false;
      });
    }
  }

  Widget _buildDeleteInput(){
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () async {
          //Implement to Edit action
          await chatProvider.deleteChatMessages(_messagesToDeleteNotifier.value, chatRoomsProvider.currentChatRoom.id!);
          await chatRoomsProvider.updateChatRooms();
          //local db action
          setState(() {
            mode=ChatPageMode.chatMode;
          });
          _messagesToDeleteNotifier.value = [];
        },
        icon: const Icon(Icons.delete, color: Colors.white),
        label: Text(
          Intl.message("deleteOption"),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditInput() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () async {
          //Implement to Edit action
          //local db action
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
          });
          _chatTextEditingController.text = "";
        },
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(
          Intl.message("editChatOption"),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.themeColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      //height: 50,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: ColorConstants.inputDecoration, width: 0.5)), color: Colors.white),
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _isInputMenuVisible
                      ? const Icon(Icons.close)
                      : const Icon(Icons.add),
                ),
                onPressed: () async {
                  if(_keyboardVisibilityController.isVisible){
                    _inputFocusNode.unfocus();
                    //wait until keyboard is fully closed
                    await Future.delayed(const Duration(milliseconds: 200));
                    setState(() {
                      _isInputMenuVisible = true;
                    });
                  } else{
                    _inputFocusNode.unfocus();
                    setState(() {
                      _isInputMenuVisible = !_isInputMenuVisible;
                    });
                  }
                },
                color: ColorConstants.primaryColor,
              ),
            ),
          ),

          // TextField
          Flexible(
            child: TextField(
              textInputAction: TextInputAction.newline,
              scrollPhysics: const BouncingScrollPhysics(),
              minLines: 1,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15
              ),
              controller: _inputTextEditingController,
              decoration: InputDecoration.collapsed(
                hintText: Intl.message("chatInputHint"),
                hintStyle: const TextStyle(color: ColorConstants.greyColor),
              ),
              focusNode: _inputFocusNode,
            ),
          ),
          // Button send message
          Material(
            color: Colors.white,
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: !_isSendEnabled || _isInputEmpty
                      ? null
                      : () async {
                    // implement on Send
                    await _onSubmitInput();
                  },
                  color: ColorConstants.primaryColor,
                )
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmitInput() async {
    // Declare these values at first because `current` values can be different during request
    final roomId = chatRoomsProvider.currentChatRoom.id!;
    final character = charactersProvider.currentCharacter;
    final now = Utilities.getTimestamp();
    final inputChatMessage = ChatMessage(
      roomId: roomId,
      characterId: character.id!,
      chatMessageType: ChatMessageType.userMessage,
      timestamp: now,
      role: "user",
      content: _inputTextEditingController.text,
    );
    await chatProvider.insertChatMessage(inputChatMessage);
    // scroll down chat list
    _scrollChatToBottom();
    // set Input text empty after inserting input message
    _inputTextEditingController.text = "";
    // request Chat by service
    if(character.service.serviceType == ServiceType.openAI){
      final service = character.service as OpenAIService;
      await chatProvider.openAIStreamCompletion(
        service,
        chatProvider.chatMessages,
        roomId,
        character,
      );
    } else if (character.service.serviceType == ServiceType.paLM){
      final service = character.service as PaLMService;
      await chatProvider.paLMChatCompletion(
        service,
        chatProvider.chatMessages,
        roomId,
        character,
      );
    }
  }

  void _networkStateListenerFunction(){
    if(chatProvider.requestState == RequestState.invalidOpenAIAPIKey){
      _openMovePageDialog(Intl.message("chatGPTAPIKeyErrorTitle"), Intl.message("chatGPTAPIisInvalid"));
    } else if (chatProvider.requestState == RequestState.invalidPaLMAPIKey){
      _openMovePageDialog(Intl.message("paLMAPIKeyErrorTitle"), Intl.message("paLMAPIisInvalid"));
    } else if (mounted && (chatProvider.requestState == RequestState.loading || chatProvider.requestState == RequestState.answering)){
      setState(() {
        _isSendEnabled = false;
      });
    } else if (mounted && (chatProvider.requestState == RequestState.initialized || chatProvider.requestState == RequestState.done)) {
      setState(() {
        _isSendEnabled = true;
      });
    }
  }

  Widget _buildInputMenu() {
    Widget buildMenuButton(Object iconOrImagePath, String label, Function onPressed) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPressed(),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconOrImagePath is IconData
                ? Icon(iconOrImagePath, color: ColorConstants.primaryColor)
                : SizedBox(
                  width: 24,
                  height: 24,
                  child: Image(
                    fit: BoxFit.scaleDown,
                    image: AssetImage(iconOrImagePath as String),
                  ),
                 ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: ColorConstants.primaryColor
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: chatProvider.getKeyboardHeight(context),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildMenuButton(Icons.edit, Intl.message("editProfile"), () {
              // Implement functionality for photo button
              if (context.mounted) {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CharacterCreationPage(
                        arguments: CharacterCreationPageArguments(
                            character: charactersProvider.currentCharacter
                        ),
                      ),
                    )
                );
              }
            }),
            buildMenuButton(Icons.settings, Intl.message("chatRoomSetting"), () {
              // Implement functionality for photo button
              if (context.mounted) {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChatRoomSettingPage(),
                    )
                );
              }
            }),
            buildMenuButton(Icons.image, Intl.message("image"), () {
              // Implement functionality for photo button
              if (context.mounted) {
                _openPasteDialog();
              }
            }),
          ],
        ),
      ),
    );
  }

}


class ChatPageArguments {
  final String characterId;

  ChatPageArguments({required this.characterId});
}