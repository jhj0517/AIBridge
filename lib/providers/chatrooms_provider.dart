import 'package:flutter/material.dart';

import '../repositories/chatrooms_repository.dart';
import '../models/models.dart';

class ChatRoomsProvider extends ChangeNotifier{

  final ChatRoomRepository chatRoomsRepository;

  List<ChatRoom> _chatRooms = [];
  List<ChatRoom> get chatRooms => _chatRooms;

  ChatRoom _currentChatRoom = ChatRoom.emptyChatRoom();
  ChatRoom get currentChatRoom => _currentChatRoom;

  ChatRoomSetting? _chatRoomSetting;
  ChatRoomSetting? get chatRoomSetting => _chatRoomSetting;

  ChatRoomsProvider({required this.chatRoomsRepository}) {
    updateChatRooms();
  }

  Future<void> updateChatRooms() async{
    _chatRooms = await chatRoomsRepository.getChatRooms();
    if(chatRooms.isNotEmpty){
      for(var room in _chatRooms){
        final lastChat = await chatRoomsRepository.getLastChat(room.id!);
        if(lastChat != null){
          room.lastMessage = lastChat.content;
          room.lastMessageTimestamp = lastChat.timestamp;
        }
      }
    }
    notifyListeners();
  }

  Future<void> updateOneChatRoom(ChatRoom chatRoom) async{
    await chatRoomsRepository.updateOneChatRoom(chatRoom);
    await updateChatRooms();
  }

  Future<void> updateCurrentChatRoom(String characterId) async{
    _currentChatRoom = await chatRoomsRepository.getOneChatroom(characterId);
    notifyListeners();
  }

  Future<void> insertChatRoom(Character character) async{
    await chatRoomsRepository.insertChatRoom(character);
    await updateChatRooms();
  }

  Future<void> deleteChatRoom(String chatRoomId) async{
    await chatRoomsRepository.deleteChatRoom(chatRoomId);
    await updateChatRooms();
  }

  Future<void> saveChatRoomSetting(ChatRoomSetting setting) async{
    _chatRoomSetting = setting;
    chatRoomsRepository.saveChatRoomSetting(setting);
    notifyListeners();
  }

  Future<void> readChatRoomSetting(
    Color themeBackgroundColor,
  ) async{
    final setting = await chatRoomsRepository.getChatRoomSetting(themeBackgroundColor);
    _chatRoomSetting = setting;
    notifyListeners();
  }

}