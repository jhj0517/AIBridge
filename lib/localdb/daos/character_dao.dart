import 'package:sqflite/sqflite.dart';

import '../../constants/sharedpreference_constants.dart';
import '../../models/sqflite/character.dart';
import '../../utils/default_character_manager.dart';
import '../sqflite_helper.dart';

class CharacterDao {
  CharacterDao({
    required this.localDB
  });

  final SQFliteHelper localDB;

  Future<List<Character>> getCharacters() async {
    final db = await localDB.database;
    final maps = await db.query(SQFliteHelper.charactersTable);

    return maps.map((json) => Character.fromMap(json)).toList();
  }

  Future<Character> getOneCharacter(String characterId) async {
    final db = await localDB.database;
    final maps = await db.query(
      SQFliteHelper.charactersTable,
      where: '${SQFliteHelper.charactersColumnId} = ?',
      whereArgs: [characterId],
    );

    return Character.fromMap(maps.first);
  }

  Future<void> insertCharacter(Character character) async {
    final db = await localDB.database;
    await db.insert(
      SQFliteHelper.charactersTable,
      character.toMap(),
    );
  }

  Future<void> insertDefaultCharacters({String userName=""}) async {
    final db = await localDB.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${SQFliteHelper.charactersTable}'));
    bool defaultsInserted = localDB.prefs.getBool(SharedPreferenceConstants.defaultInserted) ?? false;
    if (count == 0 && !defaultsInserted) {
      final List<Character> defaultCharacters = await DefaultCharacterManager.getDefaultCharacters(userName);
      for (final character in defaultCharacters) {
        await upsertCharacter(character);
      }
      await localDB.prefs.setBool(SharedPreferenceConstants.defaultInserted, true);
    }
  }

  Future<void> upsertCharacter(Character character) async {
    final db = await localDB.database;
    final result = await db.update(
      SQFliteHelper.charactersTable,
      character.toMap(),
      where: '${SQFliteHelper.charactersColumnId} = ?',
      whereArgs: [character.id],
    );
    if (result==0) await insertCharacter(character);
  }

  Future<void> updateCharacter(Character character) async {
    final db = await localDB.database;
    await db.update(
      SQFliteHelper.charactersTable,
      character.toMap(),
      where: '${SQFliteHelper.charactersColumnId} = ?',
      whereArgs: [character.id],
    );
  }

  Future<void> deleteCharacter(String id) async {
    final db = await localDB.database;
    await db.delete(
      SQFliteHelper.charactersTable,
      where: '${SQFliteHelper.charactersColumnId} = ?',
      whereArgs: [id],
    );
  }

}