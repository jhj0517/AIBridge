import 'package:sqflite/sqflite.dart';

import '../../models/sqflite/chat_room.dart';
import '../sqflite_helper.dart';

class ChatRoomDao {

  ChatRoomDao({
    required this.localDB
  });

  final SQFliteHelper localDB;

  Future<List<ChatRoom>> getChatRooms() async {
    final db = await localDB.database;
    final maps = await db.query(SQFliteHelper.chatRoomTable);

    return maps.map((json) => ChatRoom.fromMap(json)).toList();
  }

  Future<ChatRoom> getOneChatRoom(String characterId) async {
    final db = await localDB.database;
    final maps = await db.query(
      SQFliteHelper.chatRoomTable,
      where: '${SQFliteHelper.chatRoomColumnCharacterId} = ?',
      whereArgs: [characterId],
    );

    return ChatRoom.fromMap(maps.first);
  }

  Future<void> insertChatRoom(ChatRoom chatRoom) async {
    final db = await localDB.database;
    await db.insert(
      SQFliteHelper.chatRoomTable,
      chatRoom.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore
    );
  }

  Future<void> updateChatRoom(ChatRoom chatRoom) async {
    final db = await localDB.database;
    await db.update(
      SQFliteHelper.chatRoomTable,
      chatRoom.toMap(),
      where: '${SQFliteHelper.chatRoomColumnId} = ?',
      whereArgs: [chatRoom.id],
    );
  }

  Future<void> deleteChatRoom(String id) async {
    final db = await localDB.database;
    await db.delete(
      SQFliteHelper.chatRoomTable,
      where: '${SQFliteHelper.chatRoomColumnId} = ?',
      whereArgs: [id],
    );
  }

}