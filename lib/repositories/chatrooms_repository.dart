import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../localdb/localdb.dart';
import '../constants/sharedpreference_constants.dart';

class ChatRoomRepository {
  ChatRoomRepository({
    required this.chatRoomDao,
    required this.chatMessageDao,
    required this.prefs
  });

  final ChatRoomDao chatRoomDao;
  final ChatMessageDao chatMessageDao;
  final SharedPreferences prefs;

  Future<List<ChatRoom>> getChatRooms() => chatRoomDao.getChatRooms();

  Future<ChatMessage?> getLastChat(String roomId) => chatMessageDao.getLastChatMessage(roomId);

  Future<ChatRoom> getOneChatroom(String characterId) => chatRoomDao.getOneChatRoom(characterId);

  Future<void> createChatRoom(Character character) async {
    final roomId = const Uuid().v4();
    final chatRoom = ChatRoom(
      id: roomId,
      characterId: character.id!,
      userName: character.userName,
      characterName: character.characterName,
      photoBLOB: character.photoBLOB,
    );
    final firstMessage = ChatMessage.firstMessage(
      roomId,
      character.id!,
      character.firstMessage
    );
    await chatRoomDao.insertChatRoom(chatRoom);
    await chatMessageDao.insertChatMessage(firstMessage);
  }

  Future<void> updateOneChatRoom(ChatRoom chatRoom) => chatRoomDao.updateChatRoom(chatRoom);

  Future<void> deleteChatRoom(String chatRoomId) => chatRoomDao.deleteChatRoom(chatRoomId);

  Future<void> saveChatRoomSetting(ChatRoomSetting setting) async {
    String settingString = jsonEncode(setting.toJson());
    await prefs.setString(SharedPreferenceConstants.settingChatRoomJson, settingString);
  }

  Future<ChatRoomSetting> getChatRoomSetting(
    BuildContext context
  ) async {
    String? settingString = prefs.getString(SharedPreferenceConstants.settingChatRoomJson);
    if (settingString != null) {
      Map<String, dynamic> json = jsonDecode(settingString);
      return ChatRoomSetting.fromJson(json);
    }
    return ChatRoomSetting.defaultChatRoomSetting(context);
  }

}