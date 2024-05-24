import 'package:flutter/material.dart';

import 'package:aibridge/models/sqflite/chat_message.dart';
import 'package:aibridge/utils/utilities.dart';

class ChatTime extends StatelessWidget {

  const ChatTime({
    super.key,
    required this.chatMessage,
  });

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return Text(
      Utilities.hourFormat(chatMessage.timestamp),
      style: const TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
  }
}