import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoneButton extends StatelessWidget{

  const DoneButton({
    super.key,
    required this.onDone,
    this.enableDone = false
  });

  final Future<void> Function() onDone;
  final bool enableDone;

  @override
  Widget build(BuildContext context) {
    Color textColor = enableDone ? Colors.white : Colors.white38;
    return  TextButton(
      onPressed: enableDone? onDone : null,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
      child: Text(
        Intl.message("done"),
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}