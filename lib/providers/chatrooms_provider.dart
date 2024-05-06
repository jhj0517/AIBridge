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

  ChatRoomsProvider({
    required this.chatRoomsRepository
  }) {
    getChatRooms();
  }

  Future<void> getChatRooms() async{
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
    getChatRooms();
  }

  Future<void> updateCurrentChatRoom(String characterId) async{
    _currentChatRoom = (await chatRoomsRepository.getOneChatroom(characterId))!;
    notifyListeners();
  }

  Future<void> createChatRoom(Character character) async{
    await chatRoomsRepository.createChatRoom(character);
    getChatRooms();
  }

  Future<void> deleteChatRoom(String chatRoomId) async{
    await chatRoomsRepository.deleteChatRoom(chatRoomId);
    getChatRooms();
  }

  Future<void> saveChatRoomSetting(ChatRoomSetting setting) async{
    _chatRoomSetting = setting;
    chatRoomsRepository.saveChatRoomSetting(setting);
    notifyListeners();
  }

  Future<void> readChatRoomSetting(
    BuildContext context,
  ) async{
    final setting = await chatRoomsRepository.getChatRoomSetting(context);
    _chatRoomSetting = setting;
    notifyListeners();
  }

}