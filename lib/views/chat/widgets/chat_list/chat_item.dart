import 'package:aibridge/views/chat/widgets/messages/character/character_message.dart';
import 'package:aibridge/views/chat/widgets/messages/character/character_message_delete_mode.dart';
import 'package:aibridge/views/chat/widgets/messages/user/user_message.dart';
import 'package:aibridge/views/chat/widgets/messages/user/user_message_delete_mode.dart';
import 'package:flutter/material.dart';

import 'package:aibridge/models/models.dart';
import 'package:aibridge/views/chat/chat_page.dart';

class ChatItem extends StatelessWidget {

  const ChatItem({
    super.key,
    required this.item,
    required this.chatTextEditingController,
    required this.editChatFocusNode,
    required this.messagesToDeleteNotifier,
    required this.dialogCallback,
    required this.settings,
    this.character,
    this.mode = ChatPageMode.chatMode
  });

  final ChatMessage item;
  final TextEditingController chatTextEditingController;
  final FocusNode editChatFocusNode;
  final ValueNotifier<List<ChatMessage>> messagesToDeleteNotifier;
  final Future<void> Function(ChatMessage) dialogCallback;
  final ChatRoomSetting settings;
  final ChatPageMode mode;
  final Character? character;

  @override
  Widget build(BuildContext context) {
    switch (item.chatMessageType) {
      case ChatMessageType.characterMessage:
        if(mode==ChatPageMode.deleteMode){
          return CharacterMessageDeleteMode(
            character: character,
            chatMessage: item,
            settings: settings,
            mode: mode,
            messagesToDeleteNotifier: messagesToDeleteNotifier,
            chatTextEditingController: chatTextEditingController,
            editChatFocusNode: editChatFocusNode,
          );
        }
        return CharacterMessage(
          character: character,
          chatMessage: item,
          settings: settings,
          mode: mode,
          chatTextEditingController: chatTextEditingController,
          editChatFocusNode: editChatFocusNode,
          dialogCallback: dialogCallback,
        );

      case ChatMessageType.userMessage:
        if(mode==ChatPageMode.deleteMode){
          return UserMessageDeleteMode(
            chatMessage: item,
            settings: settings,
            mode: mode,
            messagesToDeleteNotifier: messagesToDeleteNotifier,
            chatTextEditingController: chatTextEditingController,
            editChatFocusNode: editChatFocusNode,
          );
        }
        return UserMessage(
          chatMessage: item,
          settings: settings,
          mode: mode,
          chatTextEditingController: chatTextEditingController,
          editChatFocusNode: editChatFocusNode,
          dialogCallback: dialogCallback,
        );
      default:
    }
    return const SizedBox.shrink();
  }

}