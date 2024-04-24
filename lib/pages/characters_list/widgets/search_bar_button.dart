import 'package:flutter/material.dart';

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