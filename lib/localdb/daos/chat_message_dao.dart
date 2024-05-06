import 'package:sqflite/sqflite.dart';

import '../../models/sqflite/chat_message.dart';
import '../sqflite_helper.dart';

class ChatMessageDao {

  ChatMessageDao({
    required this.localDB
  });

  final SQFliteHelper localDB;

  Future<ChatMessage?> getLastChatMessage(String roomId) async {
    final db = await localDB.database;
    final maps = await db.query(
      SQFliteHelper.chatMessageTable,
      where: '${SQFliteHelper.chatMessageColumnRoomId} = ?',
      whereArgs: [roomId],
      orderBy: '${SQFliteHelper.chatMessageColumnTimestamp} DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return ChatMessage.fromMap(maps.first);
  }

  Future<List<ChatMessage>> getChatMessages(String roomId) async {
    final db = await localDB.database;
    final maps = await db.query(
      SQFliteHelper.chatMessageTable,
      where: '${SQFliteHelper.chatMessageColumnRoomId} = ?',
      whereArgs: [roomId],
    );

    return maps.map((json) => ChatMessage.fromMap(json)).toList();
  }

  Future<void> insertChatMessage(ChatMessage chatMessage) async {
    final db = await localDB.database;
    await db.insert(
      SQFliteHelper.chatMessageTable,
      chatMessage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore
    );
  }

  Future<void> upsertChatMessage(ChatMessage chatMessage) async {
    final db = await localDB.database;
    final result = await db.update(
      SQFliteHelper.chatMessageTable,
      chatMessage.toMap(),
      where: '${SQFliteHelper.chatMessageColumnId} = ?',
      whereArgs: [chatMessage.id],
    );
    if (result==0) await insertChatMessage(chatMessage);
  }

  Future<void> updateChatMessage(ChatMessage chatMessage) async {
    final db = await localDB.database;
    await db.update(
      SQFliteHelper.chatMessageTable,
      chatMessage.toMap(),
      where: '${SQFliteHelper.chatMessageColumnId} = ?',
      whereArgs: [chatMessage.id],
    );
  }

  Future<void> deleteChatMessages(List<ChatMessage> messagesToDelete) async {
    final db = await localDB.database;
    final batch = db.batch();

    for (var message in messagesToDelete) {
      batch.delete(
        SQFliteHelper.chatMessageTable,
        where: '${SQFliteHelper.chatMessageColumnId} = ?',
        whereArgs: [message.id],
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> deleteOneChatMessage(String id) async {
    final db = await localDB.database;
    await db.delete(
      SQFliteHelper.chatMessageTable,
      where: '${SQFliteHelper.chatMessageColumnId} = ?',
      whereArgs: [id],
    );
  }

}