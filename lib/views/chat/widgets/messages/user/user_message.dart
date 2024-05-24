import 'package:flutter/material.dart';

import 'package:aibridge/models/sqflite/chat_message.dart';
import 'package:aibridge/models/chatroom_settings.dart';
import 'package:aibridge/views/chat/chat_page.dart';
import 'package:aibridge/views/chat/widgets/messages/chat_time.dart';
import 'package:aibridge/views/chat/widgets/messages/message_content.dart';

class UserMessage extends StatelessWidget {

  final ChatMessage chatMessage;
  final ChatRoomSetting settings;
  final ChatPageMode mode;
  final TextEditingController chatTextEditingController;
  final FocusNode editChatFocusNode;
  final Future<void> Function(ChatMessage)? dialogCallback;

  const UserMessage({
    super.key,
    required this.chatMessage,
    required this.settings,
    required this.mode,
    required this.chatTextEditingController,
    required this.editChatFocusNode,
    required this.dialogCallback,
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
            ChatTime(chatMessage: chatMessage),
            const SizedBox(width: 4.0),
            Flexible(
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
                      onLongPress: () async => dialogCallback?.call(chatMessage),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: MessageContent(
                          settings: settings,
                          mode: mode,
                          chatMessage: chatMessage,
                          chatTextEditingController: chatTextEditingController,
                          editChatFocusNode: editChatFocusNode
                        ),
                      ),
                    )
                ),
              ),
            ),
            const SizedBox(width: 10.0),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}