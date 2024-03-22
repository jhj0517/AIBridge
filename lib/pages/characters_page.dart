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

  final ScrollController listScrollController = ScrollController();
  bool isLoading = false;

  bool _isSearching = false;
  String _textSearch = "";
  TextEditingController searchBarTec = TextEditingController();
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
                ? _buildSearchBar()
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
              IconButton(
                icon: Icon(
                  _isSearching
                  ? Icons.close
                  : Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (_isSearching) {
                      searchBarFocusNode.requestFocus();
                    } else {
                      searchBarFocusNode.unfocus();
                      searchBarTec.clear();
                      _textSearch = "";
                    }
                  });
                },
              ),
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
                          List<Character> characters = charactersProvider.characters;
                          if (characters.isEmpty) {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return _buildAddButton(context);
                              },
                              itemCount: 1,
                            );
                          } else {
                            List<Character> filteredCharacters =
                            characters.where((character) =>
                            _textSearch.isEmpty ||
                            character.characterName.toLowerCase().contains(_textSearch.toLowerCase()))
                            .toList();

                            if (filteredCharacters.isNotEmpty) {
                              return ListView.builder(
                                padding: const EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 50),
                                itemBuilder: (context, index) {
                                  if (index == filteredCharacters.length) {
                                    return _buildAddButton(context);
                                  } else {
                                    return _buildItem(context, filteredCharacters[index]);
                                  }
                                },
                                itemCount: filteredCharacters.length + 1,
                                controller: listScrollController,
                              );
                            } else {
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
                          }
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
    searchBarTec.dispose();
    listScrollController.removeListener(() {});
  }

  Future<void> _init() async {
    // initialize something
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterCreationPage(
                arguments: CharacterCreationPageArguments(
                    character: character
                ),
              ),
          ),
        );
        break;
      case DialogResult.delete:
        await _openDeleteDialog(character.id!);
        break;
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
        break;
    }
  }

  Widget _buildSearchBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.search,
          color: Colors.white,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: TextFormField(
            focusNode: searchBarFocusNode,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.search,
            controller: searchBarTec,
            onChanged: (value) {
              setState(() {
                _textSearch = value;
              });
            },
            decoration: InputDecoration.collapsed(
              hintText: Intl.message("searchCharacter"),
              hintStyle: const TextStyle(
                fontSize: 15, color: ColorConstants.weakGreyColor
              ),
            ),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15
            ),
          ),
        ),
      ],
    );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CharacterProfilePage(
                        arguments: CharacterProfilePageArguments(
                            characterId: character.id!,
                        ),
                      ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    clipBehavior: Clip.hardEdge,
                    child: character.photoBLOB.isNotEmpty
                        ? SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.memory(
                          character.photoBLOB,
                          fit: BoxFit.cover,
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle_rounded,
                              size: 50,
                              color: ColorConstants.greyColor,
                            );
                          },
                        )
                    )
                        : const Icon(
                      Icons.account_circle,
                      size: 50,
                      color: ColorConstants.greyColor,
                    ),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterCreationPage(
                  arguments: CharacterCreationPageArguments(
                      character: Character.defaultCharacter()
                  ),
                ),
              ),
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

}
