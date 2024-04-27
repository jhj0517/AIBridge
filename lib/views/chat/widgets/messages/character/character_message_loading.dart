import 'package:flutter/material.dart';

import 'package:aibridge/views/chat/widgets/messages/base/base_message.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';
import 'package:aibridge/constants/constants.dart';

class CharacterMessageLoading extends BaseMessage{

  const CharacterMessageLoading({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.character,
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