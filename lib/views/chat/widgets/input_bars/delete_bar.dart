import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'bar_base.dart';

class DeleteBar extends BarBase {
  const DeleteBar({
    super.key,
    required super.onPressed
  });

  @override
  Widget buildInputBar(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.delete, color: Colors.white),
      label: Text(
        Intl.message("deleteOption"),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }

}