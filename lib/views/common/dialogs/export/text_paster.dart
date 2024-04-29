import 'package:flutter/material.dart';

import 'package:aibridge/constants/color_constants.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../base/base_dialog.dart';

class TextPaster extends StatelessWidget {
  final String title;
  final String subTitle;
  final String labelText;
  final String buttonText;
  final bool isPassword;
  final TextEditingController textFieldController;

  const TextPaster({
    super.key,
    required this.title,
    required this.subTitle,
    required this.labelText,
    required this.buttonText,
    required this.textFieldController,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        color: ColorConstants.themeColor,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              subTitle,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    cursorColor: Colors.white,
                    controller: textFieldController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                        ),
                        labelText: labelText,
                        labelStyle: const TextStyle(
                            color: Colors.white38,
                            fontSize: 15
                        )
                    ),
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    autocorrect: false,
                    obscureText: isPassword,
                  ),
                ),
                Material(
                  color: ColorConstants.themeColor, // Match the background color
                  child: IconButton(
                    icon: const Icon(
                      Icons.content_paste,
                      color: Colors.white,
                    ),
                    splashColor: Colors.white.withOpacity(0.3), // Set the splash color here
                    onPressed: () async {
                      ClipboardData? clipboardData = await Clipboard.getData('text/plain');
                      Fluttertoast.showToast(msg: Intl.message("textIsPasted"));
                      if (clipboardData != null) {
                        textFieldController.text = clipboardData.text!;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return Colors.grey.withOpacity(0.2);
                      return Colors.transparent;
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, DialogResult.yes);
                },
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: ColorConstants.themeColor,
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}