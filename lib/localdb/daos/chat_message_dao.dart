import '../../models/sqflite/character.dart';
import '../../models/sqflite/chat_message.dart';
import '../../models/sqflite/chat_room.dart';
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

    if (maps.isNotEmpty){
      return ChatMessage.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<ChatMessage>> getChatMessages(String roomId) async {
    final db = await localDB.database;
    final maps = await db.query(
      SQFliteHelper.chatMessageTable,
      where: '${SQFliteHelper.chatMessageColumnRoomId} = ?',
      whereArgs: [roomId],
    );

    return List.generate(maps.length, (i) {
      return ChatMessage.fromMap(maps[i]);
    });
  }

  Future<void> insertChatMessage(ChatMessage chatMessage) async {
    final db = await localDB.database;
    await db.insert(SQFliteHelper.chatMessageTable, chatMessage.toMap());
  }

  Future<void> insertFirstMessage(Character character, ChatMessage firstMessage) async {
    if (character.firstMessage.isNotEmpty){
      final db = await localDB.database;
      final List<Map<String, dynamic>> existingMessages = await db.query(
        SQFliteHelper.chatMessageTable,
        where: '${SQFliteHelper.chatMessageColumnCharacterId} = ?',
        whereArgs: [character.id],
      );
      final List<Map<String, dynamic>> existingChatroom = await db.query(
        SQFliteHelper.chatRoomTable,
        where: '${SQFliteHelper.chatRoomColumnCharacterId} = ?',
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
        await db.insert(SQFliteHelper.chatRoomTable, chatRoom.toMap());
        await db.insert(SQFliteHelper.chatMessageTable, firstMessage.toMap());
      }
    }
  }

  Future<void> updateStreamChatMessage(ChatMessage chatMessage) async {
    final db = await localDB.database;

    List<Map<String, dynamic>> existingMessage = await db.query(
      SQFliteHelper.chatMessageTable,
      where: '${SQFliteHelper.chatMessageColumnId} = ?',
      whereArgs: [chatMessage.id],
    );

    if (existingMessage.isNotEmpty) {
      await db.update(
        SQFliteHelper.chatMessageTable,
        chatMessage.toMap(),
        where: '${SQFliteHelper.chatMessageColumnId} = ?',
        whereArgs: [existingMessage.first[SQFliteHelper.chatMessageColumnId]],
      );
    } else {
      await db.insert(
        SQFliteHelper.chatMessageTable,
        chatMessage.toMap(),
      );
    }
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