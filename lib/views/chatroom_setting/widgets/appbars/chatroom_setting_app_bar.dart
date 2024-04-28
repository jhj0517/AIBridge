import 'package:aibridge/models/chatroom_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'done_button.dart';

class ChatRoomSettingAppBar extends StatelessWidget implements PreferredSizeWidget {

  const ChatRoomSettingAppBar({
    super.key,
    required this.currentSettings
  });

  final ChatRoomSetting currentSettings;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          Intl.message("chatRoomSetting"),
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        actions: [
          DoneButton(currentSettings: currentSettings),
        ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}