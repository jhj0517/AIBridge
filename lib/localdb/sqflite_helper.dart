import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/models.dart';
import '../utils/default_character_manager.dart';
import '../constants/sharedpreference_constants.dart';


class SQFliteHelper {
  //database
  static const _databaseName = 'aibridge_database.db';
  static String get databaseName => _databaseName;
  static const _databaseVersion = 1;
  //chatRoom Table
  static const chatRoomTable = 'chat_rooms';
  static const chatRoomColumnId = '_id';
  static const chatRoomColumnCharacterId = 'character_id';
  static const chatRoomColumnUserName = 'user_name';
  static const chatRoomColumnCharacterName = 'character_name';
  static const chatRoomColumnCharacterPhotoBLOB = 'photo_blob';
  //chatMessage Table
  static const chatMessageTable = 'chat_messages';
  static const chatMessageColumnId = '_id';
  static const chatMessageColumnRoomId = 'chat_room_id';
  static const chatMessageColumnCharacterId = 'character_id';
  static const chatMessageColumnChatMessageType = 'type';
  static const chatMessageColumnTimestamp = 'timestamp';
  static const chatMessageColumnContent = 'content';
  static const chatMessageColumnImageUrl = 'image_url';
  static const chatMessageColumnIsEditable = 'is_editable';
  //Character Table
  static const charactersTable = 'characters';
  static const charactersColumnId = '_id';
  static const charactersColumnCharacterPhotoBLOB = 'photo_blob';
  static const charactersColumnCharacterBackgroundPhotoBLOB = 'background_photo_blob';
  static const charactersColumnCharacterName = 'character_name';
  static const charactersColumnUserName = 'user_name';
  static const charactersColumnFirstMessage= 'first_message';
  static const charactersColumnService = 'service';
  //OpenAI
  static const openAITable = 'openAI';
  static const openAIColumnId = '_id';
  static const openAIColumnServiceType = 'service_type';
  static const openAIColumnCharacterId = 'character_id';
  static const openAIColumnModelName = 'model_name';
  static const openAIColumnModelId = 'model_id';
  static const openAIColumnTemperature = 'temperature';
  static const openAIColumnSystemPrompts = 'system_prompt';
  static const openAIColumnCharacterPrompt = 'character_prompt';
  //PaLM
  static const paLMTable = 'paLM';
  static const paLMColumnId = '_id';
  static const paLMColumnServiceType = 'service_type';
  static const paLMColumnCharacterId = 'character_id';
  static const paLMColumnModelName = 'model_name';
  static const paLMColumnModelId = 'model_id';
  static const paLMColumnTemperature = 'temperature';
  static const paLMColumnCandidateCount = 'candidate_count';
  static const paLMColumnContext = 'context';
  static const paLMColumnExampleInput = 'example_input';
  static const paLMColumnExampleOutput = 'example_output';

  final SharedPreferences prefs;
  SQFliteHelper({required this.prefs});

  Database? _database;
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
        await db.execute('PRAGMA foreign_keys = ON');
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

  Future<void> deleteDB() async {
    final String existingDbPath = await getDBPath();
    final File file = File(existingDbPath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}