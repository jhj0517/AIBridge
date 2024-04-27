import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/constants/color_constants.dart';


class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSendEnabled;
  final bool isMenuVisible;
  final Future<void> Function() onMenuOpen;
  final Future<void> Function() onSendChat;

  const ChatInputField({
    super.key,
    required this.onSendChat,
    required this.controller,
    required this.focusNode,
    required this.isSendEnabled,
    required this.isMenuVisible,
    required this.onMenuOpen
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: ColorConstants.inputDecoration, width: 0.5)), color: Colors.white),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: isMenuVisible
                  ? const Icon(Icons.close)
                  : const Icon(Icons.add),
            ),
            onPressed: onMenuOpen,
            color: ColorConstants.primaryColor,
          ),
          Flexible(
            child: TextField(
              textInputAction: TextInputAction.newline,
              scrollPhysics: const BouncingScrollPhysics(),
              minLines: 1,
              maxLines: 4,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15
              ),
              controller: controller,
              decoration: InputDecoration.collapsed(
                hintText: Intl.message("chatInputHint"),
                hintStyle: const TextStyle(color: ColorConstants.greyColor),
              ),
              focusNode: focusNode,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isSendEnabled ? onSendChat : null,
            color: ColorConstants.primaryColor,
          ),
        ],
      ),
    );
  }
}