import 'package:flutter/material.dart';

enum DialogResult {
  yes,
  cancel,
  edit,
  delete,
  copy,
}

abstract class BaseDialog extends StatelessWidget {
  const BaseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.zero,
      children: buildContent(context),
    );
  }

  List<Widget> buildContent(BuildContext context);
}