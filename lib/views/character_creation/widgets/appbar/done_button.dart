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
    return  IconButton(
        icon: const Icon(Icons.check),
        onPressed: enableDone? () => onDone : null,
        tooltip: Intl.message("Done"),
    );
  }

}