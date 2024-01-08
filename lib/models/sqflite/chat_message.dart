import 'package:uuid/uuid.dart';

import '../../utils/utilities.dart';
import '../../localdb/localdb.dart';
import 'character.dart';

enum ChatMessageType { userMessage, characterMessage, indicator }

class ChatMessage {
  final String? id;
  final String roomId;
  final String characterId;
  final ChatMessageType chatMessageType;
  final int timestamp;
  final String role;
  final String content;
  String imageUrl;
  bool isEditable;

  ChatMessage({
    this.id,
    required this.roomId,
    required this.characterId,
    required this.chatMessageType,
    required this.timestamp,
    required this.role,
    required this.content,
    this.imageUrl="",
    this.isEditable=false,
  });

  Map<String, dynamic> toMap() {
    var uuid = const Uuid();
    return {
      SQFliteHelper.chatMessageColumnId: id ?? uuid.v4(),
      SQFliteHelper.chatMessageColumnRoomId: roomId,
      SQFliteHelper.chatMessageColumnCharacterId: characterId,
      SQFliteHelper.chatMessageColumnChatMessageType: chatMessageType.index,
      SQFliteHelper.chatMessageColumnTimestamp: timestamp,
      SQFliteHelper.chatMessageColumnRole: role,
      SQFliteHelper.chatMessageColumnContent: content,
      SQFliteHelper.chatMessageColumnImageUrl: imageUrl,
      SQFliteHelper.chatMessageColumnIsEditable: isEditable ? 1 : 0,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map[SQFliteHelper.chatMessageColumnId] as String?,
      roomId: map[SQFliteHelper.chatMessageColumnRoomId] as String,
      characterId: map[SQFliteHelper.chatMessageColumnCharacterId] as String,
      chatMessageType: ChatMessageType.values[map[SQFliteHelper.chatMessageColumnChatMessageType] as int],
      timestamp: map[SQFliteHelper.chatMessageColumnTimestamp] as int,
      role: map[SQFliteHelper.chatMessageColumnRole] as String,
      content: map[SQFliteHelper.chatMessageColumnContent] as String,
      imageUrl: map[SQFliteHelper.chatMessageColumnImageUrl] as String,
      isEditable: (map[SQFliteHelper.chatMessageColumnIsEditable] as int) == 1,
    );
  }

  factory ChatMessage.placeHolder(){
    return ChatMessage(
        roomId: "",
        characterId: "",
        chatMessageType: ChatMessageType.indicator,
        timestamp: -1,
        role: "",
        content: ""
    );
  }

  factory ChatMessage.firstMessage(String roomId, String characterId, String content){
    var uuid = const Uuid();
    return ChatMessage(
      id: uuid.v4(),
      roomId: roomId,
      characterId: characterId,
      chatMessageType: ChatMessageType.characterMessage,
      timestamp: Utilities.getTimestamp(),
      role: "assistant",
      content: content
    );
  }

  ChatMessage copyWith({
    String? id,
    String? roomId,
    String? characterId,
    ChatMessageType? chatMessageType,
    int? timestamp,
    String? role,
    String? content,
    String? imageUrl,
    bool? isEditable,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      characterId: characterId ?? this.characterId,
      chatMessageType: chatMessageType ?? this.chatMessageType,
      timestamp: timestamp ?? this.timestamp,
      role: role ?? this.role,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      isEditable: isEditable ?? this.isEditable,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(Id: $id, roomId: $roomId, characterId: $characterId, chatMessageType: $chatMessageType, timestamp: $timestamp, role: $role, content: $content, isEditable: $isEditable)';
  }
}
