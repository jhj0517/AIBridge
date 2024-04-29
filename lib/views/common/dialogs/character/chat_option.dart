import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../base/base_dialog.dart';

class ChatOption extends BaseDialog {
  const ChatOption({super.key});

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      InkWell(
        onTap: () {
          Navigator.pop(context, DialogResult.edit);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          height: 50,
          color: Colors.transparent,
          child: Text(
            Intl.message("editChatOption"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
      const SizedBox(height: 1),
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
      const SizedBox(height: 1),
      InkWell(
        onTap: () {
          Navigator.pop(context, DialogResult.copy);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          height: 50,
          color: Colors.transparent,
          child: Text(
            Intl.message("copyChatOption"),
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