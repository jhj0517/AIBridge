import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import '../models/models.dart';
import '../pages/chat_page.dart';
import '../providers/providers.dart';
import '../constants/constants.dart';
import '../widgets/dialogs.dart';

class ChatRoomsPage extends StatefulWidget {
  const ChatRoomsPage({Key? key}) : super(key: key);

  @override
  ChatRoomsState createState() => ChatRoomsState();
}

class ChatRoomsState extends State<ChatRoomsPage> {

  late ChatRoomsProvider chatRoomsProvider;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = context.read<ThemeProvider>();
    chatRoomsProvider = context.read<ChatRoomsProvider>();
  }

  @override
  Widget build(BuildContext context) {
    chatRoomsProvider = context.watch<ChatRoomsProvider>();
    themeProvider = context.watch<ThemeProvider>();
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          width: screenSize.width,
          height: screenSize.height,
          child: const Image(
            image: AssetImage(PathConstants.characterCreationPageBackgroundPlaceholderImage),
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: themeProvider.attrs.backgroundColor,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Text(
                  Intl.message("chatRoomsPageTitle"),
                  style: const TextStyle(
                    color: ColorConstants.appbarTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            backgroundColor: themeProvider.attrs.appbarColor,
            centerTitle: false,
            automaticallyImplyLeading: false, // Add this line
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                ListView.builder(
                  itemCount: chatRoomsProvider.chatRooms.length,
                  itemBuilder: (context, index) {
                    // Display each chat room in the list.
                    return _buildItem(context, chatRoomsProvider.chatRooms[index]);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, ChatRoom? chatRoom) {
    if (chatRoom != null) {
      return Column(
        children: [
          Ink(
            color: themeProvider.attrs.backgroundColor,
            child: InkWell(
              onTap: () {
                if (Utilities.isKeyboardShowing(context)) {
                  Utilities.closeKeyboard(context);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      arguments: ChatPageArguments(
                        characterId: chatRoom.characterId,
                      ),
                    ),
                  ),
                );
              },
              onLongPress: () async {
                await _openChatRoomDialog(chatRoom);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  children: <Widget>[
                    //Profile Picture
                    Material(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      clipBehavior: Clip.hardEdge,
                      child: chatRoom.photoBLOB.isNotEmpty
                      ? SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.memory(
                          chatRoom.photoBLOB,
                          fit: BoxFit.cover,
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle_rounded,
                              size: 60,
                              color: ColorConstants.greyColor,
                            );
                          },
                        ),
                      )
                      : const Icon(
                        Icons.account_circle,
                        size: 60,
                        color: ColorConstants.greyColor,
                      ),
                    ),
                    //Name and LastMessage
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            chatRoom.characterName,
                            style: TextStyle(
                              color: themeProvider.attrs.fontColor,
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
                                      children: chatRoom.lastMessage == null
                                          ? ChatParser.parseMessageContent(Intl.message(""), null)
                                          : ChatParser.parseMessageContent(chatRoom.lastMessage!, null),
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
                                chatRoom.lastMessageTimestamp==null
                                    ? ""
                                    : Utilities.timestampIntoHourFormat(chatRoom.lastMessageTimestamp!),
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
            color: themeProvider.attrs.dividerColor,
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<void> _openChatRoomDialog(ChatRoom chatRoom) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialogs.chatRoomDialog(context, chatRoom.characterName);
        })) {
      case OnChatRoomOptionClicked.onDelete:
        await _openDeleteChatRoomDialog(context, chatRoom);
        break;
    }
  }

  Future<void> _openDeleteChatRoomDialog(BuildContext context, ChatRoom chatRoom) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialogs.deleteChatRoomDialog(context);
        })) {
      case OnDeleteChatRoomOptionClicked.onCancel:
        break;
      case OnDeleteChatRoomOptionClicked.onYes:
        await chatRoomsProvider.deleteChatRoom(chatRoom.id!);
        break;
    }
  }

}
