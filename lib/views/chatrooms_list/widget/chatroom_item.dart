import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/constants/color_constants.dart';
import 'package:aibridge/models/sqflite/chat_room.dart';
import 'package:aibridge/utils/chat_parser.dart';
import 'package:aibridge/utils/utilities.dart';
import 'package:aibridge/views/chat/chat_page.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';

class ChatRoomItem extends StatelessWidget {

  const ChatRoomItem({
    super.key,
    required this.chatRoom,
    required this.onLongPress
  });

  final ChatRoom? chatRoom;
  final Future<void> Function(ChatRoom?) onLongPress;

  @override
  Widget build(BuildContext context) {
    if (chatRoom == null){
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Ink(
          color: Theme.of(context).colorScheme.background,
          child: InkWell(
            onTap: () => _navigateToChat(context),
            onLongPress: () => onLongPress(chatRoom),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: <Widget>[
                  ProfilePicture(
                    imageBLOBData: chatRoom!.photoBLOB,
                    width: 60,
                    height: 60
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          chatRoom!.characterName,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: chatRoom!.lastMessage == null
                                        ? ChatParser.parseMessageContent(Intl.message(""), null)
                                        : ChatParser.parseMessageContent(chatRoom!.lastMessage!, null),
                                    style: const TextStyle(
                                      color: ColorConstants.greyColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            // Add LastMessageTimeStamp
                            const SizedBox(width: 25),
                            Text(
                              chatRoom!.lastMessageTimestamp==null
                                  ? ""
                                  : Utilities.timestampIntoHourFormat(chatRoom!.lastMessageTimestamp!),
                              style: const TextStyle(
                                color: ColorConstants.greyColor,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 0.1,
          thickness: 0.2,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }

  void _navigateToChat(BuildContext context){
    if (Utilities.isKeyboardShowing(context)) {
      Utilities.closeKeyboard(context);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          arguments: ChatPageArguments(
            characterId: chatRoom!.characterId,
          ),
        ),
      ),
    );
  }
}