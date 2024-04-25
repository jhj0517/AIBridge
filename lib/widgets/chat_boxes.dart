import 'dart:async';
import 'package:aibridge/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/models.dart';
import '../views/views.dart';
import '../providers/providers.dart';
import '../constants/constants.dart';
import '../utils/utils.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';


abstract class BaseChatBox extends StatelessWidget {
  final ChatMessage chatMessage;
  final ChatRoomSetting settings;
  final ChatPageMode mode;
  final TextEditingController chatTextEditingController;
  final FocusNode editChatFocusNode;
  final Future<void> Function()? dialogCallback;
  final CharactersProvider? charactersProvider;
  final ThemeProvider themeProvider;

  const BaseChatBox({
    super.key,
    required this.chatMessage,
    required this.settings,
    required this.mode,
    required this.chatTextEditingController,
    required this.editChatFocusNode,
    required this.themeProvider,
    this.dialogCallback,
    this.charactersProvider,
  });

  Widget buildMessageContent(BuildContext context) {
    if (chatMessage.imageUrl.isNotEmpty && mode == ChatPageMode.deleteMode) {
      return Image.network(
        chatMessage.imageUrl,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child; // Image is fully loaded
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    if (chatMessage.imageUrl.isNotEmpty) {
      return GestureDetector(
          onTap:() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullPhotoPage(
                  arguments: FullPhotoPageArguments(
                      title: chatMessage.imageUrl,
                      imageUrl: chatMessage.imageUrl
                  ),
                ),
              ),
            );
          },
          child: Image.network(
            chatMessage.imageUrl,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child; // Image is fully loaded
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          )
      );
    }

    if (chatMessage.isEditable) {
      return TextField(
        focusNode: editChatFocusNode,
        textInputAction: TextInputAction.newline,
        cursorColor: Colors.white,
        maxLines: null,
        autofocus: true,
        controller: chatTextEditingController,
        style: TextStyle(
          fontSize: chatMessage.chatMessageType == ChatMessageType.characterMessage
              ? settings.characterFontSize // default 16
              : settings.userFontSize, // default 16
          color: chatMessage.chatMessageType == ChatMessageType.characterMessage
              ? settings.characterFontColor // default Colors.black
              : settings.userFontColor, // default Colors.white
        ),
      );
    }

    if (settings.isRenderMarkdown) {
      return MarkdownBody(
        data: ChatParser.parseMarkDown(chatMessage.content),
        styleSheet: ChatParser.markdownStyleSheet(chatMessage.chatMessageType, settings),
      );
    }

    return RichText(
      text: TextSpan(
        children:
        ChatParser.parseMessageContent(chatMessage.content, chatMessage.chatMessageType),
        style: TextStyle(
          fontSize: chatMessage.chatMessageType == ChatMessageType.characterMessage
              ? settings.characterFontSize // default 16
              : settings.userFontSize, // default 16
          color: chatMessage.chatMessageType == ChatMessageType.characterMessage
              ? settings.characterFontColor
              : settings.userFontColor,
        ),
      ),
    );
  }

  Widget buildMessageCheckbox(bool isChecked) {
    return IgnorePointer(
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: themeProvider.attrs.fontColor,
        ),
        child: Checkbox(
          shape: const CircleBorder(),
          value: isChecked,
          onChanged: (bool? newValue) {},
        ),
      ),
    );
  }

  Widget buildTimestamp(BuildContext context) {
    return Text(
      Utilities.timestampIntoHourFormat(chatMessage.timestamp),
      style: const TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
  }

  Widget buildCharacterName(BuildContext context){
    return Text(
      charactersProvider!.currentCharacter.characterName,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: themeProvider.attrs.fontColor
      ),
    );
  }

  bool isMessageToDelete(List<ChatMessage> messagesToDelete, ChatMessage messageEntry) {
    return messagesToDelete.any((chatMessage) => chatMessage == messageEntry);
  }

  @override
  Widget build(BuildContext context);
}

class UserChatBox extends BaseChatBox {

  const UserChatBox({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.dialogCallback,
    required super.themeProvider
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 70),
              buildTimestamp(context),
              const SizedBox(width: 4.0),
              _buildChatBox(context),
              const SizedBox(width: 10.0),
            ],
          ),
          const SizedBox(height: 15),
        ],
      );
  }
  
  Widget _buildChatBox(BuildContext context){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
              color: settings.userChatBoxBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              splashColor: settings.userChatBoxBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.0),
              onLongPress: dialogCallback,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: buildMessageContent(context),
              ),
            )
        ),
      ),
    );
  }
}

class UserChatBoxDeleteMode extends BaseChatBox {
  final ValueNotifier<List<ChatMessage>> messagesToDeleteNotifier;

  const UserChatBoxDeleteMode({
    super.key,
    required this.messagesToDeleteNotifier,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.themeProvider
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        ValueListenableBuilder<List<ChatMessage>>(
          valueListenable: messagesToDeleteNotifier,
          builder: (context, messagesToDelete, child) {
            return Stack(
              children: [
                Positioned(
                  left: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: buildMessageCheckbox(
                      isMessageToDelete(messagesToDelete, chatMessage)
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      if (isMessageToDelete(messagesToDelete, chatMessage)) {
                        messagesToDeleteNotifier.value = List.from(messagesToDelete)
                          ..removeWhere((entry) => entry == chatMessage);
                      } else {
                        messagesToDeleteNotifier.value = [...messagesToDelete, chatMessage];
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 70),
                        buildTimestamp(context),
                        const SizedBox(width: 4.0),
                        _buildChatBox(context),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildChatBox(BuildContext context){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
              color: settings.userChatBoxBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: buildMessageContent(context)
            )
        ),
      ),
    );
  }
}

class CharacterChatBox extends BaseChatBox {

  final Future<void> Function() profileCallback;

  const CharacterChatBox({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.dialogCallback,
    required super.themeProvider,
    required super.charactersProvider,
    required this.profileCallback
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10.0),
              ProfilePicture(
                width: 50,
                height: 50,
                onPickImage: profileCallback,
                imageBLOBData: charactersProvider!.currentCharacter.photoBLOB,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCharacterName(context),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildChatBox(context),
                          const SizedBox(width: 4.0),
                          buildTimestamp(context),
                          const SizedBox(width: 35.0),
                        ],
                      )
                    ],
                  )
              )
            ],
          ),
          const SizedBox(height: 8)
        ],
      );
  }

  Widget _buildChatBox(BuildContext context){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
              color: settings.characterChatBoxBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              splashColor: settings.characterChatBoxBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.0),
              onLongPress: dialogCallback,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: buildMessageContent(context),
              ),
            )
        ),
      ),
    );
  }
}

class CharacterChatBoxDeleteMode extends BaseChatBox {

  final ValueNotifier<List<ChatMessage>> messagesToDeleteNotifier;

  const CharacterChatBoxDeleteMode({
    super.key,
    required this.messagesToDeleteNotifier,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.themeProvider,
    required super.charactersProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<List<ChatMessage>>(
          valueListenable: messagesToDeleteNotifier,
          builder: (context, messagesToDelete, child) {
            return InkWell(
              onTap: () {
                if (isMessageToDelete(messagesToDelete, chatMessage)) {
                  messagesToDeleteNotifier.value = List.from(messagesToDelete)
                    ..removeWhere((entry) => entry == chatMessage);
                } else {
                  messagesToDeleteNotifier.value = [...messagesToDelete, chatMessage];
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildMessageCheckbox(
                      isMessageToDelete(messagesToDelete, chatMessage)
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10.0),
                        ProfilePicture(
                          width: 50,
                          height: 50,
                          imageBLOBData: charactersProvider!.currentCharacter.photoBLOB,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildCharacterName(context),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildChatBox(context),
                                  const SizedBox(width: 4.0),
                                  buildTimestamp(context),
                                  const SizedBox(width:35.0)
                                ],
                              ),
                            ],
                          )
                        )
                      ],
                    )
                  )
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
      ]
    );
  }

  Widget _buildChatBox(BuildContext context){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
              color: settings.characterChatBoxBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: buildMessageContent(context),
            )
        ),
      ),
    );
  }
}

class CharacterChatBoxLoading extends BaseChatBox{

  const CharacterChatBoxLoading({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.themeProvider,
    required super.charactersProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 10.0),
            ProfilePicture(
              width: 50,
              height: 50,
              imageBLOBData: charactersProvider!.currentCharacter.photoBLOB,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCharacterName(context),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChatBox(),
                      const SizedBox(width: 4.0),
                      buildTimestamp(context),
                      const SizedBox(width: 35.0),
                    ],
                  )
                ],
              )
            )
          ],
        ),
        const SizedBox(height: 8)
      ],
    );
  }

  Widget _buildChatBox(){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: ColorConstants.defaultCharacterChatBoxColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
              child: Image.asset(
                PathConstants.typingDotAnimation,
                width: 30,
                height: 20,
                fit: BoxFit.fitHeight,
              ), // replace with the path to your GIF
            ),
          )
        ),
      ),
    );
  }

}