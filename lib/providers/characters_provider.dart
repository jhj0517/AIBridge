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
    getCharacters();
  }

  Future<void> getCharacters() async{
    _characters = await charactersRepository.getCharacters();
    notifyListeners();
  }

  Future<void> updateCurrentCharacter(String characterId) async {
    _currentCharacter = await charactersRepository.getOneCharacter(characterId);
    notifyListeners();
  }

  Future<void> upsertCharacter(Character character) async{
    await charactersRepository.upsertCharacter(character);
    getCharacters();
  }

  Future<void> insertDefaultCharacters({String userName=""}) async{
    await charactersRepository.insertDefaultCharacters(userName: userName);
    getCharacters();
  }

  Future<void> deleteCharacter(String characterId) async{
    await charactersRepository.deleteCharacter(characterId);
    getCharacters();
  }

}