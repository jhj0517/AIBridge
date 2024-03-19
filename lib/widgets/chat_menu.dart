import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class ChatMenu extends StatelessWidget {
  final List<ChatMenuItem> menuItems;
  final double menuHeight; // Number of items per row

  const ChatMenu({
    Key? key, required this.menuItems,
    required this.menuHeight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: menuHeight,
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10.0, // Spacing between rows
        crossAxisSpacing: 10.0, // Spacing between items
        children: menuItems.map((menuItem) => buildMenuButton(menuItem)).toList(),
      ),
    );
  }

  Widget buildMenuButton(ChatMenuItem menuItem) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: menuItem.onPressed,
        child: SizedBox(
          width: double.infinity, // Take full width available in the cell
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              menuItem.icon is IconData
              ? Icon(
                  menuItem.icon as IconData,
                  color: ColorConstants.primaryColor
              )
              : SizedBox(
                width: 24,
                height: 24,
                child: Image(
                  fit: BoxFit.scaleDown,
                  image: AssetImage(menuItem.icon as String),
                ),
              ),
              Text(
                menuItem.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: ColorConstants.primaryColor
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMenuItem{
  final Object icon;
  final String label;
  final Function() onPressed;

  const ChatMenuItem({
    required this.icon,
    required this.label,
    required this.onPressed
  });
}
