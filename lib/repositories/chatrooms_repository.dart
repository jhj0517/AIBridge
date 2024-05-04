import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

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

  Future<void> insertChatRoom(Character character) => chatRoomDao.insertChatRoom(character);

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