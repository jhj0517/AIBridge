import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/constants/color_constants.dart';
import 'done_button.dart';

class CharacterCreationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isNewChar;
  final void Function() onBack;
  final Future<void> Function() onDone;
  final bool enableDone;

  const CharacterCreationAppBar({
    super.key,
    required this.isNewChar,
    required this.onBack,
    required this.onDone,
    this.enableDone = false
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        color: Colors.white,
        onPressed: onBack,
      ),
      title: Text(
        isNewChar ? Intl.message("newCharacter") : Intl.message("editCharacterOption"),
        style: const TextStyle(color: ColorConstants.appbarTextColor),
      ),
      centerTitle: false,
      actions: [
        DoneButton(onDone: onDone, enableDone: enableDone)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}