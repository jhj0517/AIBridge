import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../constants/constants.dart';
import 'image_converter.dart';

class DefaultCharacterManager{

  static Future<List<Character>> getDefaultCharacters(String userName) async {
    final characterPhotoBLOB = await ImageConverter.convertAssetImageToBLOB(PathConstants.defaultCharacterImage);
    final characterBackgroundPhotoBLOB = await ImageConverter.convertAssetImageToBLOB(PathConstants.defaultCharacterBackgroundImage);
    const uuid = Uuid();
    final defaultCharacterId = uuid.v4();

    final Character defaultCharacter = Character(
        id: defaultCharacterId,
        photoBLOB: characterPhotoBLOB,
        backgroundPhotoBLOB: characterBackgroundPhotoBLOB,
        characterName: Intl.message("defaultCharacterName"),
        userName: userName,
        firstMessage: Intl.message("defaultCharacterFirstMessage"),
        service: OpenAIService(
          characterId: defaultCharacterId,
          modelName: ModelConstants.chatGPT3dot5,
          temperature: 1,
          systemPrompts: [
            Intl.message("defaultCharacterPersonalityPrompt"),
            Intl.message("defaultCharacterSystemPrompt")
          ],
        )
    );

    return [defaultCharacter];
  }
}