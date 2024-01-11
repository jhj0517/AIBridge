import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

enum MyTheme{
 light,
 dark
}

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  final initialTheme = MyTheme.light;

  ThemeProvider({
    required this.prefs
  }){
    _loadThemeMode();
  }

  MyTheme? _themeMode;
  MyTheme? get themeMode => _themeMode;

  ThemeAttributes get attrs => _themeMode == MyTheme.light
      ? LightThemeAttributes()
      : DarkThemeAttributes();

  void toggleTheme() {
    _themeMode = _themeMode == MyTheme.light ? MyTheme.dark : MyTheme.light;
    _saveThemeMode();
    notifyListeners();
  }

  void _loadThemeMode() {
    int? themeIndex = prefs.getInt(SharedPreferenceConstants.theme);
    _themeMode = themeIndex == null ? initialTheme : MyTheme.values[themeIndex];
  }

  void _saveThemeMode() {
    prefs.setInt(SharedPreferenceConstants.theme, _themeMode!.index);
  }
}

abstract class ThemeAttributes {
  Color get backgroundColor;
  Color get dividerColor;
  Color get fontColor;
  Color get appbarColor;
  Color get navigationBackgroundColor;
  Color get selectedNavigationItemColor;
  Color get unSelectedNavigationItemColor;
  String get toggleThemeName;
  IconData get toggleThemeIcon;
  String get gptLogoPath;
}

class LightThemeAttributes implements ThemeAttributes {
  @override
  Color get backgroundColor => const Color(0xffffffff);
  @override
  Color get dividerColor => Colors.grey[300]!;
  @override
  Color get fontColor => const Color(0xFF000000);
  @override
  Color get appbarColor => const Color(0xff000000);
  @override
  Color get navigationBackgroundColor => const Color(0xffffffff);
  @override
  Color get selectedNavigationItemColor => const Color(0xff000000);
  @override
  Color get unSelectedNavigationItemColor => const  Color(0xff808080);
  @override
  String get toggleThemeName => Intl.message("darkTheme");
  @override
  IconData get toggleThemeIcon => Icons.dark_mode;
  @override
  String get gptLogoPath => PathConstants.chatGPTImage;
}

class DarkThemeAttributes implements ThemeAttributes {
  @override
  Color get backgroundColor => const Color(0xff000000);
  @override
  Color get dividerColor => const Color(0xFF3D3D3D);
  @override
  Color get fontColor => const Color(0xFFFFFFFF);
  @override
  Color get appbarColor => const Color(0xff090909);
  @override
  Color get navigationBackgroundColor => const Color(0xff090909);
  @override
  Color get selectedNavigationItemColor => const Color(0xffffffff);
  @override
  Color get unSelectedNavigationItemColor => const  Color(0xa9a2a2a2);
  @override
  String get toggleThemeName => Intl.message("lightTheme");
  @override
  IconData get toggleThemeIcon => Icons.light_mode;
  @override
  String get gptLogoPath => PathConstants.chatGPTWhiteImage;
}
