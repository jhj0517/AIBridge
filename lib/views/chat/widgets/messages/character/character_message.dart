import 'package:aibridge/views/character_profile/character_profile_page.dart';
import 'package:flutter/material.dart';

import 'package:aibridge/views/chat/widgets/messages/base/base_message.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';

class CharacterMessage extends BaseMessage {

  const CharacterMessage({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.dialogCallback,
    required super.character,
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
                    buildCharacterName(context),
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
                                    child: buildMessageContent(context),
                                  ),
                                )
                            ),
                          ),
                        ),
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
}