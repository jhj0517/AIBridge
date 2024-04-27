import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:aibridge/models/models.dart';
import 'package:aibridge/views/chat/chat_page.dart';
import 'package:aibridge/views/full_photo_page.dart';
import 'package:aibridge/providers/characters_provider.dart';
import 'package:aibridge/utils/utils.dart';

abstract class BaseMessage extends StatelessWidget {
  final ChatMessage chatMessage;
  final ChatRoomSetting settings;
  final ChatPageMode mode;
  final TextEditingController chatTextEditingController;
  final FocusNode editChatFocusNode;
  final Future<void> Function()? dialogCallback;
  final CharactersProvider? charactersProvider;

  const BaseMessage({
    super.key,
    required this.chatMessage,
    required this.settings,
    required this.mode,
    required this.chatTextEditingController,
    required this.editChatFocusNode,
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

  Widget buildMessageCheckbox(BuildContext context, bool isChecked) {
    return IgnorePointer(
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Theme.of(context).textTheme.bodyMedium!.color,
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
          color: Theme.of(context).textTheme.bodyMedium!.color,
      ),
    );
  }

  bool isMessageToDelete(List<ChatMessage> messagesToDelete, ChatMessage messageEntry) {
    return messagesToDelete.any((chatMessage) => chatMessage == messageEntry);
  }

  @override
  Widget build(BuildContext context);
}