import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/color_constants.dart';

enum MyTheme{
 light,
 dark
}

class ThemeProvider extends ChangeNotifier {
  MyTheme _themeMode = MyTheme.dark;

  ThemeAttributes get attrs => _themeMode == MyTheme.light
      ? LightThemeAttributes()
      : DarkThemeAttributes();

  MyTheme get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == MyTheme.light ? MyTheme.dark : MyTheme.light;
    notifyListeners();
  }
}

abstract class ThemeAttributes {
  Color get backgroundColor;
  Color get dividerColor;
  Color get fontColor;
  Color get appbarColor;
  String get toggleThemeName;
  IconData get toggleThemeIcon;
}

class LightThemeAttributes implements ThemeAttributes {
  @override
  Color get backgroundColor => const Color(0xffffffff);
  @override
  Color get dividerColor => const Color(0x11000000);
  @override
  Color get fontColor => const Color(0xFF000000);
  @override
  Color get appbarColor => const Color(0xff000000);
  @override
  String get toggleThemeName => Intl.message("darkTheme");
  @override
  IconData get toggleThemeIcon => Icons.dark_mode;
}

class DarkThemeAttributes implements ThemeAttributes {
  @override
  Color get backgroundColor => const Color(0xff000000);
  @override
  Color get dividerColor => const Color(0x11000000);
  @override
  Color get fontColor => const Color(0xFFFFFFFF);
  @override
  Color get appbarColor => const Color(0xff090909); //0xff090909
  @override
  String get toggleThemeName => Intl.message("lightTheme");
  @override
  IconData get toggleThemeIcon => Icons.light_mode;
}
