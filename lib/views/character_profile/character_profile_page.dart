import 'dart:async';
import 'package:aibridge/utils/utils.dart';
import 'package:aibridge/views/character_profile/widgets/bottom_button.dart';
import 'package:aibridge/views/common/appbars/normal_app_bar.dart';
import 'package:aibridge/views/common/character/character_background.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/providers.dart';
import '../common/loading/loading_view.dart';
import '../views.dart';
import '../../models/models.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';

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
    final currentCharacter = context.select((CharactersProvider provider) => provider.currentCharacter);
    return Stack(
      children: [
        CharacterBackground(backgroundImageBLOB: currentCharacter.backgroundPhotoBLOB),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const NormalAppBar(title: "", enableBackButton: true),
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
                        imageBLOBData: currentCharacter.photoBLOB,
                        onPickImage: () => _navigateTo(
                            FullPhotoPage(
                              arguments: FullPhotoPageArguments(
                                  title: currentCharacter.characterName,
                                  photoBLOB: currentCharacter.photoBLOB
                              ),
                            )
                        )
                    ),
                    // Name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currentCharacter.characterName,
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
                          BottomButton(
                            label: Intl.message('chatOption'),
                            iconData: Icons.chat,
                            onTap: () async {
                              await _onChat();
                            },
                          ),
                          const SizedBox(width: 20),
                          BottomButton(
                              label: Intl.message('editProfile'),
                              iconData: Icons.edit,
                              onTap: () async {
                                _onEditProfile();
                              }
                          ),
                          const SizedBox(width: 20),
                          BottomButton(
                            label: Intl.message('export'),
                            iconData: Icons.file_upload_outlined,
                            onTap: () async {
                              await _onExportCharacter();
                            },
                          ),
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

  void _onEditProfile() {
    _navigateTo(CharacterCreationPage(
      arguments: CharacterCreationPageArguments(
          character: charactersProvider.currentCharacter
      ),
    ));
  }

  Future<void> _onChat() async {
    if (charactersProvider.currentCharacter.firstMessage.isNotEmpty){
      final firstChatRoom = ChatRoom.newChatRoom(charactersProvider.currentCharacter);
      final firstMessage = ChatMessage.firstMessage(firstChatRoom.id!, charactersProvider.currentCharacter.id!, charactersProvider.currentCharacter.firstMessage);
      await charactersProvider.insertFirstMessage(charactersProvider.currentCharacter, firstMessage);
    } else {
      await chatRoomsProvider.insertChatRoom(charactersProvider.currentCharacter);
    }
    chatRoomsProvider.updateChatRooms();

    if (mounted) {
      if(widget.arguments.fromChatPage == true){
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
          context,
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
  }

  Future<void> _onExportCharacter() async {
    final success = await ChunkManager.saveImageWithChunk(character: charactersProvider.currentCharacter);
    if (!success){
      Fluttertoast.showToast(msg: Intl.message("failedToExport"));
      return;
    }
    Fluttertoast.showToast(msg: Intl.message("savedInGallery"));
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