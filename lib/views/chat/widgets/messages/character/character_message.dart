import 'package:flutter/material.dart';

import 'package:aibridge/views/chat/widgets/messages/base/base_message.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';

class CharacterMessage extends BaseMessage {

  final Future<void> Function() profileCallback;

  const CharacterMessage({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.dialogCallback,
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