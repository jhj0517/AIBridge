import 'package:aibridge/views/chat/widgets/messages/character_name.dart';
import 'package:aibridge/views/chat/widgets/messages/chat_time.dart';
import 'package:aibridge/views/chat/widgets/messages/delete_check_box.dart';
import 'package:flutter/material.dart';

import 'package:aibridge/models/models.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';
import 'package:aibridge/views/chat/chat_page.dart';
import 'package:aibridge/utils/utilities.dart';
import 'package:aibridge/views/chat/widgets/messages/message_content.dart';

class CharacterMessageDeleteMode extends StatelessWidget {

  final ValueNotifier<List<ChatMessage>> messagesToDeleteNotifier;
  final ChatMessage chatMessage;
  final ChatRoomSetting settings;
  final ChatPageMode mode;
  final TextEditingController chatTextEditingController;
  final FocusNode editChatFocusNode;
  final Character? character;

  const CharacterMessageDeleteMode({
    super.key,
    required this.messagesToDeleteNotifier,
    required this.chatMessage,
    required this.settings,
    required this.mode,
    required this.chatTextEditingController,
    required this.editChatFocusNode,
    required this.character,
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
                    DeleteCheckBox(
                      isChecked: isMessageToDelete(messagesToDelete, chatMessage)
                    ),
                    Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10.0),
                            ProfilePicture(
                              width: 50,
                              height: 50,
                              imageBLOBData: character!.photoBLOB,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CharacterName(character: character),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
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
                                                  child: MessageContent(
                                                    settings: settings,
                                                    mode: mode,
                                                    chatMessage: chatMessage,
                                                    chatTextEditingController: chatTextEditingController,
                                                    editChatFocusNode: editChatFocusNode
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4.0),
                                        ChatTime(chatMessage: chatMessage),
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

  bool isMessageToDelete(List<ChatMessage> messagesToDelete, ChatMessage messageEntry) {
    return messagesToDelete.any((chatMessage) => chatMessage == messageEntry);
  }
}