import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/models.dart';
import '../utils/default_character_manager.dart';
import '../constants/sharedpreference_constants.dart';


class SQFliteHelper {
  //database
  static final _databaseName = 'aibridge_database.db';
  static String get databaseName => _databaseName;
  static final _databaseVersion = 1;
  //chatRoom Table
  static final chatRoomTable = 'chat_rooms';
  static final chatRoomColumnId = '_id';
  static final chatRoomColumnCharacterId = 'character_id';
  static final chatRoomColumnUserName = 'user_name';
  static final chatRoomColumnCharacterName = 'character_name';
  static final chatRoomColumnCharacterPhotoBLOB = 'photo_blob';
  //chatMessage Table
  static final chatMessageTable = 'chat_messages';
  static final chatMessageColumnId = '_id';
  static final chatMessageColumnRoomId = 'chat_room_id';
  static final chatMessageColumnCharacterId = 'character_id';
  static final chatMessageColumnChatMessageType = 'type';
  static final chatMessageColumnTimestamp = 'timestamp';
  static final chatMessageColumnRole = 'role';
  static final chatMessageColumnContent = 'content';
  static final chatMessageColumnImageUrl = 'image_url';
  static final chatMessageColumnIsEditable = 'is_editable';
  //Character Table
  static final charactersTable = 'characters';
  static final charactersColumnId = '_id';
  static final charactersColumnCharacterPhotoBLOB = 'photo_blob';
  static final charactersColumnCharacterBackgroundPhotoBLOB = 'background_photo_blob';
  static final charactersColumnCharacterName = 'character_name';
  static final charactersColumnUserName = 'user_name';
  static final charactersColumnFirstMessage= 'first_message';
  static final charactersColumnService = 'service';
  //OpenAI
  static final openAITable = 'openAI';
  static final openAIColumnId = '_id';
  static final openAIColumnServiceType = 'service_type';
  static final openAIColumnCharacterId = 'character_id';
  static final openAIColumnModelName = 'model_name';
  static final openAIColumnModelId = 'model_id';
  static final openAIColumnTemperature = 'temperature';
  static final openAIColumnSystemPrompts = 'system_prompt';
  static final openAIColumnCharacterPrompt = 'character_prompt';
  //PaLM
  static final paLMTable = 'paLM';
  static final paLMColumnId = '_id';
  static final paLMColumnServiceType = 'service_type';
  static final paLMColumnCharacterId = 'character_id';
  static final paLMColumnModelName = 'model_name';
  static final paLMColumnModelId = 'model_id';
  static final paLMColumnTemperature = 'temperature';
  static final paLMColumnCandidateCount = 'candidate_count';
  static final paLMColumnContext = 'context';
  static final paLMColumnExampleInput = 'example_input';
  static final paLMColumnExampleOutput = 'example_output';

  Database? _database;

  final SharedPreferences prefs;
  SQFliteHelper({required this.prefs});

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDBPath();

    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON'); // Enable DELETE CASCADE
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $charactersTable (
      $charactersColumnId TEXT PRIMARY KEY,
      $charactersColumnCharacterPhotoBLOB BLOB NOT NULL,      
      $charactersColumnCharacterBackgroundPhotoBLOB BLOB NOT NULL,            
      $charactersColumnCharacterName TEXT NOT NULL,
      $charactersColumnUserName TEXT NOT NULL,
      $charactersColumnFirstMessage TEXT NOT NULL,
      $charactersColumnService TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE $chatRoomTable (
      $chatRoomColumnId TEXT PRIMARY KEY,
      $chatRoomColumnCharacterId TEXT NOT NULL,
      $chatRoomColumnUserName TEXT NOT NULL,
      $chatRoomColumnCharacterName TEXT NOT NULL,
      $chatRoomColumnCharacterPhotoBLOB BLOB NOT NULL,      
      FOREIGN KEY ($chatRoomColumnCharacterId) REFERENCES $charactersTable($charactersColumnId) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE $chatMessageTable (
      $chatMessageColumnId TEXT PRIMARY KEY,
      $chatMessageColumnCharacterId TEXT NOT NULL,
      $chatMessageColumnRoomId TEXT NOT NULL,
      $chatMessageColumnChatMessageType INTEGER NOT NULL,
      $chatMessageColumnTimestamp INTEGER NOT NULL,
      $chatMessageColumnRole TEXT NOT NULL,
      $chatMessageColumnContent TEXT NOT NULL,
      $chatMessageColumnImageUrl TEXT NOT NULL,
      $chatMessageColumnIsEditable INTEGER NOT NULL,
      FOREIGN KEY ($chatMessageColumnRoomId) REFERENCES $chatRoomTable($chatRoomColumnId) ON DELETE CASCADE,
      FOREIGN KEY ($chatMessageColumnCharacterId) REFERENCES $charactersTable($charactersColumnId) ON DELETE CASCADE
    )
    ''');
  }

  Future<String> getDBPath() async {
    final path = await getDatabasesPath();
    return join(path, _databaseName);
  }

  Future<File> getDBFile() async {
    return File(await getDBPath());
  }

  Future<void> clearDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
    }
    _database = null;
  }

  Future<List<ChatRoom>> getChatRooms() async {
    final db = await database;
    final maps = await db.query(chatRoomTable);

    return List.generate(maps.length, (i) {
      return ChatRoom.fromMap(maps[i]);
    });
  }

  Future<ChatRoom> getOneChatRoom(String characterId) async {
    final db = await database;
    final maps = await db.query(
      chatRoomTable,
      where: '$chatRoomColumnCharacterId = ?',
      whereArgs: [characterId],
    );

    return ChatRoom.fromMap(maps.first);
  }

  Future<ChatMessage?> getLastChatMessage(String roomId) async {
    final db = await database;
    final maps = await db.query(
      chatMessageTable,
      where: '$chatMessageColumnRoomId = ?',
      whereArgs: [roomId],
      orderBy: '$chatMessageColumnTimestamp DESC',
      limit: 1,
    );

    if (maps.isNotEmpty){
      return ChatMessage.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<ChatMessage>> getChatMessages(String roomId) async {
    final db = await database;
    final maps = await db.query(
      chatMessageTable,
      where: '$chatMessageColumnRoomId = ?',
      whereArgs: [roomId],
    );

    return List.generate(maps.length, (i) {
      return ChatMessage.fromMap(maps[i]);
    });
  }

  Future<List<Character>> getCharacters() async {
    final db = await database;
    final maps = await db.query(charactersTable);

    return List.generate(maps.length, (i) {
      return Character.fromMap(maps[i]);
    });
  }

  Future<Character> getOneCharacter(String characterId) async {
    final db = await database;
    final maps = await db.query(
      charactersTable,
      where: '$charactersColumnId = ?',
      whereArgs: [characterId],
    );

    return Character.fromMap(maps.first);
  }

  Future<void> insertChatRoom(Character character) async {
    final db = await database;
    final List<Map<String, dynamic>> existingChatroom = await db.query(
      chatRoomTable,
      where: '$chatRoomColumnCharacterId = ?',
      whereArgs: [character.id],
    );
    if(existingChatroom.isEmpty){
      ChatRoom chatRoom = ChatRoom(
        characterId: character.id!,
        userName: character.userName,
        characterName: character.characterName,
        photoBLOB: character.photoBLOB,
      );
      await db.insert(chatRoomTable, chatRoom.toMap());
    }
  }

  Future<void> insertChatMessage(ChatMessage chatMessage) async {
    final db = await database;
    await db.insert(chatMessageTable, chatMessage.toMap());
  }

  Future<void> insertFirstMessage(Character character, ChatMessage firstMessage) async {
    if (character.firstMessage.isNotEmpty){
      final db = await database;
      final List<Map<String, dynamic>> existingMessages = await db.query(
        chatMessageTable,
        where: '$chatMessageColumnCharacterId = ?',
        whereArgs: [character.id],
      );
      final List<Map<String, dynamic>> existingChatroom = await db.query(
        chatRoomTable,
        where: '$chatRoomColumnCharacterId = ?',
        whereArgs: [character.id],
      );
      if (existingMessages.isEmpty && existingChatroom.isEmpty) {
        final chatRoom = ChatRoom(
          id: firstMessage.roomId,
          characterId: character.id!,
          userName: character.userName,
          characterName: character.characterName,
          photoBLOB: character.photoBLOB,
        );
        await db.insert(chatRoomTable, chatRoom.toMap());
        await db.insert(chatMessageTable, firstMessage.toMap());
      }
    }
  }

  Future<void> insertOrUpdateCharacter(Character character) async {
    final db = await database;
    final List<Map<String, dynamic>> existingCharacter = await db.query(
      charactersTable,
      where: '$charactersColumnId = ?',
      whereArgs: [character.id],
    );
    if(existingCharacter.isEmpty){
      await db.insert(charactersTable, character.toMap());
    } else {
      await updateCharacter(character);
      // update Chatroom
      final List<Map<String, dynamic>> existingChatroom = await db.query(
        chatRoomTable,
        where: '$chatRoomColumnCharacterId = ?',
        whereArgs: [character.id],
      );
      if(existingChatroom.isNotEmpty){
        ChatRoom chatRoom = ChatRoom.fromMap(existingChatroom.first);
        final updatedChatRoom = ChatRoom(
            id: chatRoom.id!,
            characterId: character.id!,
            userName: character.userName,
            characterName: character.characterName,
            photoBLOB: character.photoBLOB,
            lastMessageTimestamp: chatRoom.lastMessageTimestamp,
            lastMessage: chatRoom.lastMessage
        );
        await updateChatRoom(updatedChatRoom);
      }
    }
  }

  Future<void> insertDefaultCharacters(String userName) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $charactersTable'));
    bool defaultsInserted = prefs.getBool(SharedPreferenceConstants.defaultInserted) ?? false;
    if (count == 0 && !defaultsInserted) {
      final List<Character> defaultCharacters = await DefaultCharacterManager.getDefaultCharacters(userName);
      for (final character in defaultCharacters) {
        await insertOrUpdateCharacter(character);
      }
      await prefs.setBool(SharedPreferenceConstants.defaultInserted, true);
    }
  }

  Future<void> updateChatRoom(ChatRoom chatRoom) async {
    final db = await database;
    await db.update(
      chatRoomTable,
      chatRoom.toMap(),
      where: '$chatRoomColumnId = ?',
      whereArgs: [chatRoom.id],
    );
  }

  Future<void> updateOneChatMessage(ChatMessage chatMessage) async {
    final db = await database;
    await db.update(
      chatMessageTable,
      chatMessage.toMap(),
      where: '$chatMessageColumnId = ?',
      whereArgs: [chatMessage.id],
    );
  }

  Future<void> updateStreamChatMessage(ChatMessage chatMessage) async {
    final db = await database;

    // Query to find the latest record with the same characterId and roomId
    List<Map<String, dynamic>> existingRecords = await db.query(
      chatMessageTable,
      where: '${SQFliteHelper.chatMessageColumnId} = ?',
      whereArgs: [chatMessage.id],
    );

    if (existingRecords.isNotEmpty) {
      await db.update(
        chatMessageTable,
        chatMessage.toMap(),
        where: '${SQFliteHelper.chatMessageColumnId} = ?',
        whereArgs: [existingRecords.first[SQFliteHelper.chatMessageColumnId]],
      );
    } else {
      // If no record exists, insert the new one
      await db.insert(
        chatMessageTable,
        chatMessage.toMap(),
      );
    }
  }

  Future<void> updateCharacter(Character character) async {
    final db = await database;
    await db.update(
      charactersTable,
      character.toMap(),
      where: '$charactersColumnId = ?',
      whereArgs: [character.id],
    );
  }

  Future<void> deleteChatRoom(String id) async {
    final db = await database;
    await db.delete(
      chatRoomTable,
      where: '$chatRoomColumnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteOneChatMessage(String id) async {
    final db = await database;
    await db.delete(
      chatMessageTable,
      where: '$chatMessageColumnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteChatMessages(List<ChatMessage> messagesToDelete) async {
    final db = await database;
    final batch = db.batch();

    for (var message in messagesToDelete) {
      batch.delete(
        chatMessageTable,
        where: '$chatMessageColumnId = ?',
        whereArgs: [message.id],
      );
    }

    // Commit the batch operation
    await batch.commit(noResult: true);
  }

  Future<void> deleteCharacter(String id) async {
    final db = await database;
    await db.delete(
      charactersTable,
      where: '$charactersColumnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteDB() async {
    final String existingDbPath = await getDBPath();
    final File file = File(existingDbPath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}