import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import 'character.dart';
import '../../localdb/localdb.dart';

class ChatRoom {
  final String? id;
  final String characterId;
  final String userName;
  final String characterName;
  final Uint8List photoBLOB;
  String? lastMessage;
  int? lastMessageTimestamp;

  ChatRoom({
    this.id,
    required this.characterId,
    required this.userName,
    required this.characterName,
    required this.photoBLOB,
    this.lastMessage,
    this.lastMessageTimestamp,
  });

  Map<String, dynamic> toMap() {
    var uuid = const Uuid();
    return {
      SQFliteHelper.chatRoomColumnId: id ?? uuid.v4(),
      SQFliteHelper.chatRoomColumnCharacterId: characterId,
      SQFliteHelper.chatRoomColumnUserName: userName,
      SQFliteHelper.chatRoomColumnCharacterName: characterName,
      SQFliteHelper.chatRoomColumnCharacterPhotoBLOB: photoBLOB,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map[SQFliteHelper.chatRoomColumnId] as String?,
      characterId: map[SQFliteHelper.chatRoomColumnCharacterId] as String,
      userName: map[SQFliteHelper.chatRoomColumnUserName] as String,
      characterName: map[SQFliteHelper.chatRoomColumnCharacterName] as String,
      photoBLOB: map[SQFliteHelper.chatRoomColumnCharacterPhotoBLOB] as Uint8List,
    );
  }

  factory ChatRoom.emptyChatRoom() {
    return ChatRoom(
        characterId: "",
        userName: "",
        characterName: "",
        photoBLOB: Uint8List(0),
        lastMessage: "",
        lastMessageTimestamp: -1
    );
  }

  factory ChatRoom.newChatRoom(Character character){
    var uuid = const Uuid();
    return ChatRoom(
      id: uuid.v4(),
      characterId: character.id!,
      userName: character.userName,
      characterName: character.characterName,
      photoBLOB: character.photoBLOB
    );
  }

  @override
  String toString() {
    return 'ChatRoom(id: $id, characterId: $characterId, userName: $userName, botName: $characterName, photoBLOB: ${photoBLOB.length} bytes, lastMessage: $lastMessage, lastMessageTimestamp: $lastMessageTimestamp)';
  }
}
