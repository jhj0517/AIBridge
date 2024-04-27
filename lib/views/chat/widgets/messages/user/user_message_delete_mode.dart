import 'package:flutter/material.dart';

import '../base/base_message.dart';
import 'package:aibridge/models/models.dart';

class UserMessageDeleteMode extends BaseMessage {
  final ValueNotifier<List<ChatMessage>> messagesToDeleteNotifier;

  const UserMessageDeleteMode({
    super.key,
    required this.messagesToDeleteNotifier,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
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
                      context, isMessageToDelete(messagesToDelete, chatMessage)
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