import 'package:flutter/material.dart';
import '../base/base_message.dart';


class UserMessage extends BaseMessage {

  const UserMessage({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.dialogCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 70),
            buildTimestamp(context),
            const SizedBox(width: 4.0),
            _buildChatBox(context),
            const SizedBox(width: 10.0),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildChatBox(BuildContext context){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
              color: settings.userChatBoxBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              splashColor: settings.userChatBoxBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.0),
              onLongPress: () async => dialogCallback?.call(chatMessage),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: buildMessageContent(context),
              ),
            )
        ),
      ),
    );
  }
}