import 'package:aibridge/views/chatrooms_list/widget/chatrooms_list.dart';
import 'package:aibridge/views/common/appbars/normal_app_bar.dart';
import 'package:aibridge/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../constants/constants.dart';
import '../../widgets/dialogs.dart';

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
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: NormalAppBar(title: Intl.message("chatRoomsPageTitle")),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                ChatRoomsList(
                  onLongPress: (chatroom) async {
                    await _openChatRoomDialog(chatroom!);
                  }
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openChatRoomDialog(ChatRoom chatRoom) async {
    final result = await showDialog(
        context: context,
        builder: (context) => ChatRoomOption(characterName: chatRoom.characterName),
    );

    switch(result){
      case DialogResult.delete:
        await _openDeleteChatRoomDialog(context, chatRoom);
        break;
    }
  }

  Future<void> _openDeleteChatRoomDialog(BuildContext context, ChatRoom chatRoom) async {
    final result = await showDialog(
      context: context,
      builder: (context) => WarningDialog(
        icon: Icons.delete,
        title: Intl.message("deleteChatroom"),
        message: Intl.message("deleteChatroomConfirm")
      ),
    );

    switch(result){
      case DialogResult.cancel:
        break;
      case DialogResult.yes:
        await chatRoomsProvider.deleteChatRoom(chatRoom.id!);
        break;
    }
  }

}
