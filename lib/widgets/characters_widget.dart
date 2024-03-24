import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/color_constants.dart';

class CharacterSearchBar extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CharacterSearchBar({
    super.key,
    required this.focusNode,
    required this.controller,
    this.onChanged,
  });

  @override
  State<CharacterSearchBar> createState() => _CharacterSearchBarState();
}

class _CharacterSearchBarState extends State<CharacterSearchBar> {

  @override
  Widget build(BuildContext context) {
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
            focusNode: widget.focusNode,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.search,
            controller: widget.controller,
            onChanged: (value) {
              widget.onChanged?.call(value);
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
}

class SearchBarButton extends StatefulWidget {
  final Function() onToggle;

  const SearchBarButton({
    super.key,
    required this.onToggle,
  });

  @override
  State<SearchBarButton> createState() => _SearchBarButtonState();
}

class _SearchBarButtonState extends State<SearchBarButton> {
  bool _isSearching=false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isSearching ? Icons.close : Icons.search,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          _isSearching = !_isSearching;
          widget.onToggle();
        });
      },
    );
  }
}