import 'package:shared_preferences/shared_preferences.dart';

import '../localdb/localdb.dart';
import '../models/models.dart';
import '../constants/constants.dart';

class ChatRepository {
  final SharedPreferences prefs;
  final ChatMessageDao dao;

  ChatRepository({
    required this.prefs,
    required this.dao
  });

  Future<List<ChatMessage>> getChatMessages(String roomId) => dao.getChatMessages(roomId);

  Future<void> insertChatMessage(ChatMessage chatMessage) => dao.insertChatMessage(chatMessage);

  Future<void> deleteOneChatMessage(String id) => dao.delete

  Future<void> deleteChatMessages(List<ChatMessage> messagesToDelete) async{
    await sqfliteHelper.deleteChatMessages(messagesToDelete);
  }

  Future<void> updateOneChatMessage(ChatMessage chatMessage) async{
    await sqfliteHelper.updateOneChatMessage(chatMessage);
  }

  Future<void> updateStreamChatMessage(ChatMessage chatMessage) async{
    await sqfliteHelper.updateStreamChatMessage(chatMessage);
  }

  Future<ChatMessage?> queryLastChatMessage(String roomId) async{
    return await sqfliteHelper.getLastChatMessage(roomId);
  }

  Future<void> setKeyboardHeight(double keyboardHeight) async{
    await prefs.setDouble(SharedPreferenceConstants.keyKeybaordHeight, keyboardHeight);
  }

  double? getKeyboardHeight() {
    return prefs.getDouble(SharedPreferenceConstants.keyKeybaordHeight);
  }

}