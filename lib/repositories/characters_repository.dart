import '../localdb/localdb.dart';
import '../models/models.dart';

class CharactersRepository {

  final CharacterDao characterDao;
  final ChatMessageDao chatMessageDao;

  CharactersRepository({
    required this.characterDao,
    required this.chatMessageDao,
  });

  Future<List<Character>> getCharacters() => characterDao.getCharacters();

  Future<Character> getOneCharacter(String characterId) => characterDao.getOneCharacter(characterId);

  Future<void> insertOrUpdateCharacter(Character character) => characterDao.insertOrUpdateCharacter(character);

  Future<void> insertFirstMessage(Character character, ChatMessage firstMessage) => chatMessageDao.insertFirstMessage(character, firstMessage);

  Future<void> deleteCharacter(String characterId) => characterDao.deleteCharacter(characterId);
}