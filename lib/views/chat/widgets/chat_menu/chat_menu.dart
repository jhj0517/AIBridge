import 'package:aibridge/views/chat/widgets/chat_menu/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMenu extends StatelessWidget {
  final double menuHeight;
  final List<MenuItem> items;

  const ChatMenu({
    super.key,
    required this.menuHeight,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: menuHeight,
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10.0, // Spacing between rows
        crossAxisSpacing: 10.0, // Spacing between items
        children: items
      ),
    );
  }
}