import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';
import '../pages/pages.dart';
import '../constants/constants.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class CharacterProfilePage extends StatefulWidget {
  const CharacterProfilePage({Key? key, required this.arguments}) : super(key: key);

  final CharacterProfilePageArguments arguments;

  @override
  CharacterProfileState createState() => CharacterProfileState();
}

class CharacterProfileState extends State<CharacterProfilePage> {

  late ChatRoomsProvider chatRoomsProvider;
  late CharactersProvider charactersProvider;

  bool _isLoading = true;

  final TextEditingController exportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatRoomsProvider = context.read<ChatRoomsProvider>();
    charactersProvider = context.read<CharactersProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  Widget build(BuildContext context) {
    CharactersProvider characterProvider = context.watch<CharactersProvider>();
    return Stack(
      children: [
        // Background placeholder image
        const SizedBox.expand(
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(PathConstants.defaultCharacterBackgroundImage),
          ),
        ),
        // Background image
        SizedBox.expand(
          child: Image.memory(
            characterProvider.currentCharacter.backgroundPhotoBLOB,
            fit: BoxFit.cover,
            errorBuilder: (context, object, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
        // Apply a color filter on top of the background image
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: ColorConstants.appbarBackgroundColor,
            elevation: 0, // Remove AppBar Shadow
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: null,
            centerTitle: false,
          ),
          // Content
          body: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile picture
                    _buildProfilePicture(),
                    // Name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        characterProvider.currentCharacter.characterName,
                        style: const TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      color: Colors.white30,
                      thickness: 1,
                      endIndent: 20,
                      indent: 20,
                    ),
                    // Chatting and Edit Profile buttons
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChatButton(widget.arguments),
                          const SizedBox(width: 20),
                          _buildEditProfileButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: _isLoading ? const LoadingView() : const SizedBox.shrink(),
        )
      ],
    );
  }

  @override
  void dispose() {
    exportController.dispose();
    super.dispose();
  }

  Future<void> _init() async{
    await charactersProvider.updateCurrentCharacter(widget.arguments.characterId);
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildProfilePicture(){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPhotoPage(
              arguments: FullPhotoPageArguments(
                  title: charactersProvider.currentCharacter.characterName,
                  photoBLOB: charactersProvider.currentCharacter.photoBLOB
              ),
            ),
          ),
        );
      },
      child:Material(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        clipBehavior: Clip.hardEdge,
        child: charactersProvider.currentCharacter.photoBLOB.isNotEmpty
            ? SizedBox(
            width: 100,
            height: 100,
            child: Image.memory(
              charactersProvider.currentCharacter.photoBLOB,
              fit: BoxFit.cover,
              errorBuilder: (context, object, stackTrace) {
                return const Icon(
                  Icons.account_circle_rounded,
                  size: 100,
                  color: ColorConstants.greyColor,
                );
              },
            )
        )
            : const Icon(
          Icons.account_box_rounded,
          size: 100,
          color: ColorConstants.greyColor,
        ),
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return Flexible(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 80, minHeight: 80),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterCreationPage(
                    arguments: CharacterCreationPageArguments(
                        character: charactersProvider.currentCharacter
                    ),
                  ),
                ),
              );
            },
            child: Column(
              children: [
                const SizedBox(height: 15),
                const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  Intl.message('editProfile'),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        )
    );
  }


  Widget _buildChatButton(CharacterProfilePageArguments arguments) {
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 80, minHeight: 80),
        child: InkWell(
          onTap: () async {
            //Chat Button On Tap event
            if (charactersProvider.currentCharacter.firstMessage.isNotEmpty){
              // This only insert Chatroom and first message in case there's no chatroom
              final firstChatRoom = ChatRoom.firstChatRoom(charactersProvider.currentCharacter);
              final firstMessage = ChatMessage.firstMessage(firstChatRoom.id!, charactersProvider.currentCharacter.id!, charactersProvider.currentCharacter.firstMessage);
              await charactersProvider.insertFirstMessage(charactersProvider.currentCharacter, firstMessage);
            } else {
              await chatRoomsProvider.insertChatRoom(charactersProvider.currentCharacter);
            }
            chatRoomsProvider.updateChatRooms();

            if (context.mounted) {
              if(widget.arguments.comingFromChatPage){
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                        arguments: ChatPageArguments(
                            characterId: widget.arguments.characterId
                        )
                    ),
                  ),
                );
              }
            }
          },
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Icon(
                Icons.chat,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                Intl.message('chatOption'),
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class CharacterProfilePageArguments {
  final String characterId;
  final bool comingFromChatPage;

  CharacterProfilePageArguments({
    required this.characterId,
    required this.comingFromChatPage
  }); // note : just receive Character
}
