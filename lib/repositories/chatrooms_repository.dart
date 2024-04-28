import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../localdb/sqflite_helper.dart';
import '../constants/sharedpreference_constants.dart';

class ChatRoomRepository {
  ChatRoomRepository({required this.sqfliteHelper, required this.prefs});

  final SQFliteHelper sqfliteHelper;
  final SharedPreferences prefs;

  Future<List<ChatRoom>> getChatRooms() async{
    return sqfliteHelper.getChatRooms();
  }

  Future<ChatMessage?> getLastChat(String roomId) async{
    return sqfliteHelper.getLastChatMessage(roomId);
  }

  Future<ChatRoom> getOneChatroom(String characterId) async {
    return sqfliteHelper.getOneChatRoom(characterId);
  }

  Future<void> insertChatRoom(Character character) async{
    await sqfliteHelper.insertChatRoom(character);
  }

  Future<void> updateOneChatRoom(ChatRoom chatRoom) async{
    await sqfliteHelper.updateChatRoom(chatRoom);
  }

  Future<void> deleteChatRoom(String chatRoomId) async{
    await sqfliteHelper.deleteChatRoom(chatRoomId);
  }

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