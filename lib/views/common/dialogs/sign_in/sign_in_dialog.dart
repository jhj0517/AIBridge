import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../base/base_dialog.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:aibridge/providers/auth_provider.dart';

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
