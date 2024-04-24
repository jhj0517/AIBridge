import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/constants/color_constants.dart';
import 'character_search_bar.dart';
import 'search_bar_button.dart';


class CharactersListAppBar extends StatefulWidget implements PreferredSizeWidget {

  final TextEditingController searchBarController;
  final FocusNode searchBarFocusNode;
  final Function(String) onQueryChanged;
  final Function onToggle;

  const CharactersListAppBar({
    super.key,
    required this.searchBarController,
    required this.searchBarFocusNode,
    required this.onQueryChanged,
    required this.onToggle,
  });

  @override
  CharactersListAppBarState createState() => CharactersListAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CharactersListAppBarState extends State<CharactersListAppBar> {
  bool _isSearching = false;

  void _toggleSearch() {
    setState(() {
      widget.onToggle();

      _isSearching = !_isSearching;

      if (_isSearching) {
        widget.searchBarFocusNode.requestFocus();
      } else {
        widget.searchBarFocusNode.unfocus();
        widget.searchBarController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
      ? CharacterSearchBar(
        focusNode: widget.searchBarFocusNode,
        controller: widget.searchBarController,
        onChanged: widget.onQueryChanged,
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
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        SearchBarButton(onToggle: _toggleSearch),
      ],
    );
  }
}