import 'package:flutter/material.dart';

import 'package:aibridge/views/chat/widgets/messages/message_content.dart';
import 'package:aibridge/models/chatroom_settings.dart';
import 'package:aibridge/models/sqflite/character.dart';
import 'package:aibridge/models/sqflite/chat_message.dart';
import 'package:aibridge/views/character_profile/character_profile_page.dart';
import 'package:aibridge/views/chat/chat_page.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';
import 'package:aibridge/views/chat/widgets/messages/character_name.dart';
import 'package:aibridge/views/chat/widgets/messages/chat_time.dart';

class CharacterMessage extends StatelessWidget {
  final ChatMessage chatMessage;
  final ChatRoomSetting settings;
  final ChatPageMode mode;
  final TextEditingController chatTextEditingController;
  final FocusNode editChatFocusNode;
  final Future<void> Function(ChatMessage)? dialogCallback;
  final Character? character;

  const CharacterMessage({
    super.key,
    required this.chatMessage,
    required this.settings,
    required this.mode,
    required this.chatTextEditingController,
    required this.editChatFocusNode,
    required this.dialogCallback,
    required this.character,
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
              onPickImage: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CharacterProfilePage(
                          arguments: CharacterProfilePageArguments(
                              characterId: character!.id!,
                          )
                      ),
                    )
                );
              },
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
                                child: InkWell(
                                  splashColor: settings.characterChatBoxBackgroundColor.withOpacity(0.5),
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
                                    )
                                  ),
                                )
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        ChatTime(chatMessage: chatMessage),
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
}