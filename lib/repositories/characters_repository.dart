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

  Future<void> upsertCharacter(Character character) => characterDao.upsertCharacter(character);

  Future<void> insertDefaultCharacters({String userName=""}) => characterDao.insertDefaultCharacters(userName: userName);

  Future<void> deleteCharacter(String characterId) => characterDao.deleteCharacter(characterId);
}