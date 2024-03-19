import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/color_constants.dart';

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

abstract class InputBarBase extends StatelessWidget {
  final Future<void> Function()? onPressed;

  const InputBarBase({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: buildInputBar(context),
    );
  }

  Widget buildInputBar(BuildContext context);
}

class DeleteBar extends InputBarBase {
  const DeleteBar({
    super.key,
    required super.onPressed
  });

  @override
  Widget buildInputBar(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.delete, color: Colors.white),
      label: Text(
        Intl.message("deleteOption"),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }

}

class EditBar extends InputBarBase{
  const EditBar({
    super.key,
    required super.onPressed
  });

  @override
  Widget buildInputBar(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit, color: Colors.white),
      label: Text(
        Intl.message("editChatOption"),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.themeColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }

}
