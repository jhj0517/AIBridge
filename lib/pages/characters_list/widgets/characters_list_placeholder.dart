import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/constants/color_constants.dart';

class CharactersListPlaceHolder extends StatelessWidget {
  const CharactersListPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        Intl.message("noCharacter"),
        style: const TextStyle(
          fontSize: 20,
          color: ColorConstants.themeColor,
          fontWeight: FontWeight.normal,
          fontFamily: "MouldyCheeseRegular",
        ),
      ),
    );
  }
}