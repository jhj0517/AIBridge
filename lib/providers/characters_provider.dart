import 'package:aibridge/utils/chat_parser.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../repositories/characters_repository.dart';

class CharactersProvider extends ChangeNotifier {

  final CharactersRepository charactersRepository;

  List<Character> _characters=[];
  List<Character> get characters => _characters;

  Character _currentCharacter = Character.defaultCharacter();
  Character get currentCharacter => _currentCharacter;

  CharactersProvider({required this.charactersRepository}) {
    updateCharacters();
  }

  Future<void> updateCharacters() async{
    _characters = await charactersRepository.getCharacters();
    notifyListeners();
  }

  Future<void> updateCurrentCharacter(String characterId) async {
    _currentCharacter = await charactersRepository.getOneCharacter(characterId);
    notifyListeners();
  }

  Future<void> insertOrUpdateCharacter(Character character) async{
    await charactersRepository.insertOrUpdateCharacter(character);
    updateCharacters();
  }

  Future<void> insertDefaultCharacters({String userName=""}) async{
    await charactersRepository.insertDefaultCharacters(userName: userName);
    updateCharacters();
  }

  Future<void> insertFirstMessage(Character character, ChatMessage firstMessage) async{
    final message = firstMessage.copyWith(content: ChatParser.parsePrompt(firstMessage.content, character));
    await charactersRepository.insertFirstMessage(character, message);
    updateCharacters();
  }

  Future<void> deleteCharacter(String characterId) async{
    await charactersRepository.deleteCharacter(characterId);
    updateCharacters();
  }

}