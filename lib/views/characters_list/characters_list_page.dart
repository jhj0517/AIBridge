import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/loading/loading_view.dart';
import '../common/dialogs/base/base_dialog.dart';
import '../common/dialogs/character/character_option.dart';
import '../common/dialogs/character/delete_check_dialog.dart';
import 'widgets/characters_list_app_bar.dart';
import 'widgets/characters_list.dart';
import 'widgets/floating_add_button.dart';
import '../../constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import '../views.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({super.key});

  @override
  State createState() => CharactersListPageState();
}

class CharactersListPageState extends State<CharactersListPage> {
  CharactersListPageState({Key? key});

  bool isLoading = false;

  bool _isSearching = false;
  String _query="";
  TextEditingController searchBarController = TextEditingController();
  FocusNode searchBarFocusNode = FocusNode();

  late CharactersProvider charactersProvider;
  late ChatRoomsProvider chatRoomsProvider;

  @override
  void initState() {
    super.initState();
    charactersProvider = context.read<CharactersProvider>();
    chatRoomsProvider = context.read<ChatRoomsProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          width: screenSize.width,
          height: screenSize.height,
          child: const Image(
            image: AssetImage(PathConstants.charactersPageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: CharactersListAppBar(
            searchBarController: searchBarController,
            searchBarFocusNode: searchBarFocusNode,
            onQueryChanged: (text) {
              setState(() => _query = text );
            },
            onToggle: () {
              setState(() {
                _isSearching = !_isSearching;
                _query = "";
              });
            }
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    Expanded(
                      child: Consumer<CharactersProvider>(
                        builder: (ctx, charactersProvider, child){
                          List<Character> filteredItems = _getFilteredCharacters(charactersProvider.characters, _query);
                          return CharacterList(
                            items: filteredItems,
                            onLongPress: (character) async => await _openCharacterOptionDialog(character),
                            onTap: (character) => _onCharacterTap(character)
                          );
                        },
                      )
                    ),
                  ],
                ),
                // Loading
                Positioned(
                  child: isLoading ? const LoadingView() : const SizedBox.shrink(),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingAddButton(onTap: _onAddButtonTap),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
    searchBarFocusNode.dispose();
  }

  List<Character> _getFilteredCharacters(List<Character> list,String searchText) {
    if (searchText.isEmpty) return list;
    return list.where((character) =>
        character.characterName.toLowerCase().contains(searchText.toLowerCase())).toList();
  }


  Future<void> _openCharacterOptionDialog(Character? character) async {
    if(character==null){
      return;
    }

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
        await chatRoomsProvider.getChatRooms();
    }
  }

  void _onCharacterTap(Character? character){
    if (character == null){
      return;
    }

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
  }

  void _onAddButtonTap(){
    _navigateTo(
        CharacterCreationPage(
          arguments: CharacterCreationPageArguments(
              character: Character.defaultCharacter()
          ),
        )
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
