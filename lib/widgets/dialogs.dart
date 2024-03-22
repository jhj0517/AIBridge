import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../constants/constants.dart';

enum DialogResult {
  yes,
  cancel,
  edit,
  delete,
  copy,
}

enum SocialLogins {
  google,
  apple,
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

class CharacterOption extends BaseDialog{
  final String characterName;

  const CharacterOption({
    super.key,
    required this.characterName
  });

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        height: 50,
        color: Colors.transparent,
        child: Text(
          characterName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.pop(context, DialogResult.edit);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          height: 50,
          color: Colors.transparent,
          child: Text(
            Intl.message("editCharacterOption"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
      const SizedBox(height: 1),
      InkWell(
        onTap: () {
          Navigator.pop(context, DialogResult.delete);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          height: 50,
          color: Colors.transparent,
          child: Text(
            Intl.message("deleteCharacterOption"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    ];
  }
}

class SignInDialog extends BaseDialog{

  const SignInDialog({
    super.key,
  });

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        height: 50,
        color: Colors.transparent,
        child: Text(
          Intl.message("signIn"),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SocialLoginButton(
        buttonType: SocialLoginButtonType.google,
        text: Intl.message("googleSignIn"),
        onPressed: () {
          Navigator.pop(context, SocialLogins.google);
        }
      ),
      SocialLoginButton(
        buttonType: SocialLoginButtonType.apple,
        text: Intl.message("appleSignIn"),
        onPressed: () {
          Navigator.pop(context, SocialLogins.apple);
        }
      ),
    ];
  }
}

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

class ChatOption extends BaseDialog {
  const ChatOption({super.key});

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      InkWell(
        onTap: () {
          Navigator.pop(context, DialogResult.edit);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          height: 50,
          color: Colors.transparent,
          child: Text(
            Intl.message("editChatOption"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
      const SizedBox(height: 1),
      InkWell(
        onTap: () {
          Navigator.pop(context, DialogResult.delete);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          height: 50,
          color: Colors.transparent,
          child: Text(
            Intl.message("deleteChatOption"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
      const SizedBox(height: 1),
      InkWell(
        onTap: () {
          Navigator.pop(context, DialogResult.copy);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          height: 50,
          color: Colors.transparent,
          child: Text(
            Intl.message("copyChatOption"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    ];
  }

}

class WarningDialog extends BaseDialog {
  final IconData icon;
  final String title;
  final String message;

  const WarningDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.message
  });

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      Container(
        color: ColorConstants.themeColor,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
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
              Intl.message('cancel'),
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
              Intl.message('yes'),
              style: const TextStyle(color: ColorConstants.primaryColor, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ];
  }

}

class ChatRoomOption extends BaseDialog {
  final String characterName;

  const ChatRoomOption({
    super.key,
    required this.characterName
  });

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        height: 50,
        color: Colors.transparent,
        child: Text(
          characterName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.pop(context, DialogResult.delete);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          height: 50,
          color: Colors.transparent,
          child: Text(
            Intl.message("deleteChatOption"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    ];
  }

}

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