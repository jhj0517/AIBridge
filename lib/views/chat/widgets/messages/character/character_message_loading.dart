import 'package:aibridge/models/sqflite/character.dart';
import 'package:aibridge/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aibridge/views/common/character/profile_picture.dart';
import 'package:aibridge/constants/constants.dart';
import 'package:aibridge/providers/chat_provider.dart';

class CharacterMessageLoading extends StatelessWidget{

  const CharacterMessageLoading({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (ctx, chatProvider, _) {
        if (chatProvider.requestState != RequestState.loading){
          return const SizedBox.shrink();
        }

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
                        Text(
                          character!.characterName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
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
                            Text(
                              Utilities.timestampIntoHourFormat(DateTime.now().millisecondsSinceEpoch),
                              style: const TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey,
                              ),
                            ),
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
    );
  }

}