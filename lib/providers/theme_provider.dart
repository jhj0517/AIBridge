import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

enum MyTheme{
 light,
 dark
}

class ThemeProvider extends ChangeNotifier {
  MyTheme _themeMode = MyTheme.light;

  ThemeColors get colors => _themeMode == MyTheme.light
      ? LightThemeColors()
      : DarkThemeColors();

  MyTheme get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == MyTheme.light ? MyTheme.dark : MyTheme.light;
    debugPrint("themeMode : ${themeMode.name}");
    notifyListeners();
  }
}

abstract class ThemeColors {
  Color get backgroundColor;
  Color get dividerColor;
  Color get fontColor;
}

class LightThemeColors implements ThemeColors {
  @override
  Color get backgroundColor => const Color(0xffffffff);
  @override
  Color get dividerColor => const Color(0x11000000);
  @override
  Color get fontColor => const Color(0xFF000000);
}

class DarkThemeColors implements ThemeColors {
  @override
  Color get backgroundColor => const Color(0xff000000);
  @override
  Color get dividerColor => const Color(0x11000000);
  @override
  Color get fontColor => const Color(0xFFFFFFFF);
}
