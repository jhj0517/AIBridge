import 'package:flutter/material.dart';

import '../message_content.dart';
import 'package:aibridge/models/models.dart';
import 'package:aibridge/views/chat/chat_page.dart';
import 'package:aibridge/views/chat/widgets/messages/chat_time.dart';
import 'package:aibridge/views/chat/widgets/messages/delete_check_box.dart';

class UserMessageDeleteMode extends StatelessWidget {
  final ValueNotifier<List<ChatMessage>> messagesToDeleteNotifier;
  final ChatMessage chatMessage;
  final ChatRoomSetting settings;
  final ChatPageMode mode;
  final TextEditingController chatTextEditingController;
  final FocusNode editChatFocusNode;

  const UserMessageDeleteMode({
    super.key,
    required this.messagesToDeleteNotifier,
    required this.chatMessage,
    required this.settings,
    required this.mode,
    required this.chatTextEditingController,
    required this.editChatFocusNode,
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
                  child: DeleteCheckBox(isChecked: isMessageToDelete(messagesToDelete, chatMessage))
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
                                child: Container(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                    child: MessageContent(
                                      settings: settings,
                                      mode: mode,
                                      chatMessage: chatMessage,
                                      chatTextEditingController: chatTextEditingController,
                                      editChatFocusNode: editChatFocusNode
                                    )
                                )
                            ),
                          ),
                        ),
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

  bool isMessageToDelete(List<ChatMessage> messagesToDelete, ChatMessage messageEntry) {
    return messagesToDelete.any((chatMessage) => chatMessage == messageEntry);
  }
}