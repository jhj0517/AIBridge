import 'package:aibridge/models/chatroom_settings.dart';
import 'package:aibridge/providers/chatrooms_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DoneButton extends StatelessWidget {

  const DoneButton({
    super.key,
    required this.currentSettings
  });

  final ChatRoomSetting currentSettings;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final provider = Provider.of<ChatRoomsProvider>(context, listen: false);
        provider.saveChatRoomSetting(currentSettings);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
      child: Text(
        Intl.message("done"),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}