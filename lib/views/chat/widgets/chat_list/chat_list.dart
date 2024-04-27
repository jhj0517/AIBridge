import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aibridge/providers/chat_provider.dart';
import 'package:aibridge/models/models.dart';
import 'package:aibridge/views/chat/chat_page.dart';
import 'chat_item.dart';

class ChatList extends StatefulWidget{

  const ChatList({
    super.key,
    required this.list,
    required this.character,
    required this.isLoading,
    required this.mode,
    required this.chatScrollController,
    required this.chatTextEditingController,
    required this.editChatFocusNode,
    required this.messagesToDeleteNotifier,
    required this.dialogCallback,
    required this.settings,
  });

  final List<ChatMessage> list;
  final Character character;
  final bool isLoading;
  final ChatPageMode mode;
  final ScrollController chatScrollController;
  final TextEditingController chatTextEditingController;
  final FocusNode editChatFocusNode;
  final ValueNotifier<List<ChatMessage>> messagesToDeleteNotifier;
  final Future<void> Function(ChatMessage) dialogCallback;
  final ChatRoomSetting settings;

  @override
  ChatListState createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) { // reverse solution: //solution from https://stackoverflow.com/questions/70577942/flutter-resizetoavoidbottominset-true-not-working-with-expanded-listview
        final chatMessages = chatProvider.chatMessages.reversed.toList();
        return Container(
          color: widget.settings.chatRoomBackgroundColor,
          child: Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                cacheExtent: widget.isLoading? double.maxFinite: null, // without this, scrollChatToBottom() at first does not work
                padding: const EdgeInsets.only(top: 10),
                controller: widget.chatScrollController,
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final item = chatMessages[index];
                  return ChatItem(
                    item: item,
                    character: widget.character,
                    chatTextEditingController: widget.chatTextEditingController,
                    editChatFocusNode: widget.editChatFocusNode,
                    messagesToDeleteNotifier: widget.messagesToDeleteNotifier,
                    dialogCallback: widget.dialogCallback,
                    settings: widget.settings,
                    mode: widget.mode,
                  );
                }
            ),
          ),
        );
      },
    );
  }

}
