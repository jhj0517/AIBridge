import '../localdb/localdb.dart';
import '../models/models.dart';

class CharactersRepository {

  final SQFliteHelper sqfliteHelper;

  CharactersRepository({required this.sqfliteHelper});

  Future<List<Character>> getCharacters() async{
    return sqfliteHelper.getCharacters();
  }

  Future<Character> getOneCharacter(String characterId) async {
    return sqfliteHelper.getOneCharacter(characterId);
  }

  Future<void> insertOrUpdateCharacter(Character character) async{
    await sqfliteHelper.insertOrUpdateCharacter(character);
  }

  Future<void> insertFirstMessage(Character character, ChatMessage firstMessage) async{
    await sqfliteHelper.insertFirstMessage(character, firstMessage);
  }

  Future<void> deleteCharacter(String characterId) async{
    await sqfliteHelper.deleteCharacter(characterId);
  }
}