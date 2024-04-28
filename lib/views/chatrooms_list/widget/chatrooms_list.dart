import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aibridge/providers/chatrooms_provider.dart';
import 'package:aibridge/models/sqflite/chat_room.dart';
import 'chatroom_item.dart';

class ChatRoomsList extends StatelessWidget {

  const ChatRoomsList({
    super.key,
    required this.onLongPress
  });

  final Future<void> Function(ChatRoom?) onLongPress;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatRoomsProvider>(
      builder: (ctx, chatRoomProvider, child) {
        return ListView.builder(
          itemCount: chatRoomProvider.chatRooms.length,
          itemBuilder: (context, index) {
            final item = chatRoomProvider.chatRooms[index];
            return ChatRoomItem(
              chatRoom: item,
              onLongPress: onLongPress
            );
          },
        );
      }
    );
  }
}