import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/sqflite/character.dart';

class Utilities {
  static bool isKeyboardShowing(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom != 0;
  }

  static closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static String tokenFormat(double value) {
    final numberFormat = NumberFormat("###,##0.##");
    return numberFormat.format(value);
  }

  static launchURL(String url) async {
    launchUrl(Uri.parse(url)).onError(
          (error, stackTrace) {
        debugPrint("Url is not valid!");
        return false;
      },
    );
  }

  static int getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }


  static String timestampIntoHourFormat(int timestamp) {
    if(timestamp==-1){
      return "";
    } else {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      DateFormat dateFormat = DateFormat('a h:mm');
      return dateFormat.format(dateTime);
    }
  }
}
