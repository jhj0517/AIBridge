import 'package:aibridge/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../base/base_dialog.dart';

class DeleteCheckDialog extends BaseDialog {
  const DeleteCheckDialog({super.key});

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      Container(
        color: ColorConstants.themeColor,
        padding: const EdgeInsets.only(bottom: 10, top: 10,right: 10,left: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: const Icon(
                Icons.delete,
                size: 30,
                color: Colors.white,
              ),
            ),
            Text(
              Intl.message("deleteCharacterOption"),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              Intl.message("deleteCharacterConfirm"),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, DialogResult.cancel);
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.cancel,
                color: ColorConstants.primaryColor,
              ),
            ),
            Text(
              Intl.message("cancel"),
              style: const TextStyle(color: ColorConstants.primaryColor, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, DialogResult.yes);
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.check_circle,
                color: ColorConstants.primaryColor,
              ),
            ),
            Text(
              Intl.message("yes"),
              style: const TextStyle(color: ColorConstants.primaryColor, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ];
  }

}