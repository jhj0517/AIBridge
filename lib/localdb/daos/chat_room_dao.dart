import '../../models/sqflite/character.dart';
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

    return List.generate(maps.length, (i) {
      return ChatRoom.fromMap(maps[i]);
    });
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

  Future<void> insertChatRoom(Character character) async {
    final db = await localDB.database;
    final List<Map<String, dynamic>> existingChatroom = await db.query(
      SQFliteHelper.chatRoomTable,
      where: '${SQFliteHelper.chatRoomColumnCharacterId} = ?',
      whereArgs: [character.id],
    );
    if(existingChatroom.isEmpty){
      ChatRoom chatRoom = ChatRoom(
        characterId: character.id!,
        userName: character.userName,
        characterName: character.characterName,
        photoBLOB: character.photoBLOB,
      );
      await db.insert(SQFliteHelper.chatRoomTable, chatRoom.toMap());
    }
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