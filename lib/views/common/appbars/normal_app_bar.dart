import 'package:aibridge/constants/constants.dart';
import 'package:flutter/material.dart';

class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool enableBackButton;

  const NormalAppBar({
    super.key,
    required this.title,
    this.enableBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: ColorConstants.appbarTextColor,
        ),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: false,
      leading: enableBackButton ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}