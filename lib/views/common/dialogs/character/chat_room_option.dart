import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../base/base_dialog.dart';

class ChatRoomOption extends BaseDialog {
  final String characterName;

  const ChatRoomOption({
    super.key,
    required this.characterName
  });

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        height: 50,
        color: Colors.transparent,
        child: Text(
          characterName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.pop(context, DialogResult.delete);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          height: 50,
          color: Colors.transparent,
          child: Text(
            Intl.message("deleteChatOption"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    ];
  }

}