import 'package:shared_preferences/shared_preferences.dart';

import '../localdb/localdb.dart';
import '../models/models.dart';
import '../constants/constants.dart';

class ChatRepository {
  final SharedPreferences prefs;
  final SQFliteHelper sqfliteHelper;

  ChatRepository({required this.prefs,required this.sqfliteHelper});

  Future<List<ChatMessage>> getChatMessages(String roomId) async{
    return sqfliteHelper.getChatMessages(roomId);
  }

  Future<void> insertChatMessage(ChatMessage chatMessage) async{
    await sqfliteHelper.insertChatMessage(chatMessage);
  }

  Future<void> deleteOneChatMessage(String id) async{
    await sqfliteHelper.deleteOneChatMessage(id);
  }

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