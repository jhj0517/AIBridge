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
    await updateCharacters();
  }

  Future<void> insertFirstMessage(Character character, ChatMessage firstMessage) async{
    await charactersRepository.insertFirstMessage(character, firstMessage);
    await updateCharacters();
  }

  Future<void> deleteCharacter(String characterId) async{
    await charactersRepository.deleteCharacter(characterId);
    await updateCharacters();
  }

}