import 'dart:async';
import 'package:aibridge/widgets/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../utils/utils.dart';
import 'pages.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  State createState() => CharactersPageState();
}

class CharactersPageState extends State<CharactersPage> {
  CharactersPageState({Key? key});

  bool isLoading = false;

  bool _isSearching = false;
  String _query="";
  TextEditingController searchBarController = TextEditingController();
  FocusNode searchBarFocusNode = FocusNode();

  late ThemeProvider themeProvider;
  late CharactersProvider charactersProvider;
  late ChatRoomsProvider chatRoomsProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = context.read<ThemeProvider>();
    charactersProvider = context.read<CharactersProvider>();
    chatRoomsProvider = context.read<ChatRoomsProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = context.watch<ThemeProvider>();
    charactersProvider = context.watch<CharactersProvider>();
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        //background
        Positioned(
          width: screenSize.width,
          height: screenSize.height,
          child: const Image(
            image: AssetImage(PathConstants.charactersPageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: themeProvider.attrs.backgroundColor,
          appBar: AppBar(
            title: _isSearching
                ? CharacterSearchBar(
                  focusNode: searchBarFocusNode,
                  controller: searchBarController,
                  onChanged: (text) {
                    setState(() => _query = text );
                  },
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      Intl.message('charactersPageTitle'),
                      style: const TextStyle(
                        color: ColorConstants.appbarTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            backgroundColor: themeProvider.attrs.appbarColor,
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              SearchBarButton(
                onToggle: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (_isSearching) {
                      searchBarFocusNode.requestFocus();
                    } else {
                      searchBarFocusNode.unfocus();
                      searchBarController.clear();
                      _query = "";
                    }
                  });
                },
              )
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                // List
                Column(
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (BuildContext context) {
                          List<Character> filteredItems = _getFilteredCharacters(_query);
                          if (_isSearching && _query.isEmpty){
                            return Center(
                              child: Text(
                                Intl.message("noCharacter"),
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: ColorConstants.themeColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "MouldyCheeseRegular"
                                ),
                              ),
                            );
                          }

                          if (filteredItems.isEmpty) {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return _buildAddButton(context);
                              },
                              itemCount: 1,
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 50),
                            itemBuilder: (context, index) {
                              if (index == filteredItems.length) {
                                return _buildAddButton(context);
                              } else {
                                return _buildItem(context, filteredItems[index]);
                              }
                            },
                            itemCount: filteredItems.length + 1,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Loading
                Positioned(
                  child: isLoading ? const LoadingView() : const SizedBox
                      .shrink(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
  }

  Future<void> _init() async {
    // initialize something
  }

  List<Character> _getFilteredCharacters(String searchText) {
    if (searchText.isEmpty) return charactersProvider.characters;
    return charactersProvider.characters.where((character) =>
        character.characterName.toLowerCase().contains(searchText.toLowerCase())).toList();
  }


  Future<void> _openCharacterOptionDialog(Character character) async {
    final dialogResult = await showDialog(
        context: context,
        builder: (context) => CharacterOption(
          characterName: character.characterName
        ),
    );

    switch (dialogResult){
      case DialogResult.edit:
        _navigateTo(
          CharacterCreationPage(
            arguments: CharacterCreationPageArguments(
                character: character
            ),
          ),
        );

      case DialogResult.delete:
        await _openDeleteDialog(character.id!);
    }
  }

  Future<void> _openDeleteDialog(String characterId) async {
    final dialogResult = await showDialog(
      context: context,
      builder: (context) => const DeleteCheckDialog(),
    );

    switch(dialogResult){
      case DialogResult.cancel:
        break;
      case DialogResult.yes:
        await charactersProvider.deleteCharacter(characterId);
        await chatRoomsProvider.updateChatRooms();
    }
  }

  Widget _buildItem(BuildContext context, Character? character) {
    if (character == null){
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Ink(
          color: themeProvider.attrs.backgroundColor,
          child: InkWell(
            onLongPress: () async {
              await _openCharacterOptionDialog(character);
            },
            onTap: () {
              if (Utilities.isKeyboardShowing(context)) {
                Utilities.closeKeyboard(context);
              }
              _navigateTo(
                  CharacterProfilePage(
                    arguments: CharacterProfilePageArguments(
                      characterId: character.id!,
                    ),
                  )
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: <Widget>[
                  ProfilePicture(
                    width: 50,
                    height: 50,
                    imageBLOBData: character.photoBLOB,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          character.characterName,
                          style: TextStyle(
                            color: themeProvider.attrs.fontColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
          thickness: 0.3,
          color: themeProvider.attrs.dividerColor,
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: themeProvider.attrs.dividerColor, // Set border color here
            width: 0.2, // Set border width here
          ),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            _navigateTo(
                CharacterCreationPage(
                  arguments: CharacterCreationPageArguments(
                      character: Character.defaultCharacter()
                  ),
                )
            );
          },
          child: Ink(
            color: themeProvider.attrs.backgroundColor,
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.add_circle_outline_sharp,
              size: 24.0,
              color: themeProvider.attrs.fontColor,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(StatefulWidget page){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

}
