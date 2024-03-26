import 'dart:async';
import 'package:aibridge/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';
import '../pages/pages.dart';
import '../constants/constants.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../utils/exif_manager.dart';

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
        // Background image
        SizedBox.expand(
          child: Image.memory(
            characterProvider.currentCharacter.backgroundPhotoBLOB,
            fit: BoxFit.cover,
            errorBuilder: (context, object, stackTrace) {
              return const LoadingView();
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
                    ProfilePicture(
                      width: 100,
                      height: 100,
                      imageBLOBData: charactersProvider.currentCharacter.photoBLOB,
                      onPickImage: () => _navigateTo(
                        FullPhotoPage(
                          arguments: FullPhotoPageArguments(
                              title: charactersProvider.currentCharacter.characterName,
                              photoBLOB: charactersProvider.currentCharacter.photoBLOB
                          ),
                        )
                      )
                    ),
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
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChatButton(widget.arguments),
                          const SizedBox(width: 20),
                          _buildEditProfileButton(),
                          const SizedBox(width: 20),
                          _buildExportButton()
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

  Future<void> _navigateTo<T extends Widget>(T page) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
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
              final firstChatRoom = ChatRoom.newChatRoom(charactersProvider.currentCharacter);
              final firstMessage = ChatMessage.firstMessage(firstChatRoom.id!, charactersProvider.currentCharacter.id!, charactersProvider.currentCharacter.firstMessage);
              await charactersProvider.insertFirstMessage(charactersProvider.currentCharacter, firstMessage);
            } else {
              await chatRoomsProvider.insertChatRoom(charactersProvider.currentCharacter);
            }
            chatRoomsProvider.updateChatRooms();

            if (context.mounted) {
              if(widget.arguments.fromChatPage == true){
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

  Widget _buildExportButton() {
    return Flexible(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 80, minHeight: 80),
          child: InkWell(
            onTap: () async {
              final success = await ChunkManager.saveImageWithChunk(character: charactersProvider.currentCharacter);
              if (!success){
                Fluttertoast.showToast(msg: Intl.message("failedToExport"));
                return;
              }
              Fluttertoast.showToast(msg: Intl.message("savedInGallery"));
            },
            child: Column(
              children: [
                const SizedBox(height: 15),
                const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  Intl.message('export'),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        )
    );
  }

}

class CharacterProfilePageArguments {
  final String characterId;
  final bool? fromChatPage;

  CharacterProfilePageArguments({
    required this.characterId,
    this.fromChatPage=false
  }); // note : just receive Character
}
// Clean this.