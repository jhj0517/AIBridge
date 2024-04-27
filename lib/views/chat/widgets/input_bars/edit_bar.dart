import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bar_base.dart';
import 'package:aibridge/constants/color_constants.dart';

class EditBar extends BarBase{
  const EditBar({
    super.key,
    required super.onPressed
  });

  @override
  Widget buildInputBar(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit, color: Colors.white),
      label: Text(
        Intl.message("editChatOption"),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.themeColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }

}