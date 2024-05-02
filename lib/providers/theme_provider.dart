import 'package:aibridge/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

enum ThemeModes{
 light,
 dark
}

class ThemeProvider extends ChangeNotifier {

  ThemeProvider({
    required this.prefs
  }){
    _loadTheme();
  }

  final SharedPreferences prefs;
  final initialThemeMode = ThemeModes.light;

  ThemeAttributes _attrs = LightThemeAttributes();
  ThemeAttributes get attrs => _attrs;

  Future<void> toggleTheme() async {
    bool isLight = attrs.mode == ThemeModes.light;
    _attrs = isLight ? DarkThemeAttributes() : LightThemeAttributes();
    _saveTheme();
    notifyListeners();
  }

  void _loadTheme() {
    int? modeIndex = prefs.getInt(SharedPreferenceConstants.theme);
    ThemeModes mode = modeIndex == null ? initialThemeMode : ThemeModes.values[modeIndex];
    bool isLight = mode == ThemeModes.light;
    _attrs = isLight ? LightThemeAttributes() : DarkThemeAttributes();
  }

  Future<void> _saveTheme() async {
    prefs.setInt(SharedPreferenceConstants.theme, attrs.mode.index);
  }

}

abstract class ThemeAttributes {
  ThemeModes get mode;
  ThemeData get themeData;
  Color get fontColor;
  String get toggleThemeName;
  IconData get toggleThemeIcon;
  String get gptLogoPath;
}

class LightThemeAttributes implements ThemeAttributes {
  @override
  ThemeModes get mode => ThemeModes.light;
  @override
  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const  ColorScheme.light().copyWith(
      background: const Color(0xFFFFFFFF),
      primary: const Color(0xFF000000),
      secondary: const Color(0xFFE1A7FF),
    ),
    dividerColor: Colors.grey[300]!,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: const Color(0xff000000)
    ),
    textTheme: const TextTheme().copyWith().apply(
      bodyColor: const Color(0xFF000000)
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
      selectedItemColor: const Color(0xff000000),
      unselectedItemColor: const Color(0xff808080),
      backgroundColor: const Color(0xffffffff)
    ),
  );
  @override
  Color get fontColor => const Color(0xFF000000);
  @override
  String get toggleThemeName => Intl.message("darkTheme");
  @override
  IconData get toggleThemeIcon => Icons.dark_mode;
  @override
  String get gptLogoPath => PathConstants.chatGPTImage;
}

class DarkThemeAttributes implements ThemeAttributes {
  @override
  ThemeModes get mode => ThemeModes.dark;
  @override
  ThemeData get themeData => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const  ColorScheme.dark().copyWith(
        background: const Color(0xff000000),
        primary: const Color(0xFF000000),
        secondary: const Color(0xFFE1A7FF),
      ),
      dividerColor: const Color(0xFF3D3D3D),
      appBarTheme: const AppBarTheme().copyWith(),
      textTheme: const TextTheme().copyWith().apply(
          bodyColor: const Color(0xFFFFFFFF)
      ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
      selectedItemColor: const Color(0xffffffff),
      unselectedItemColor: const Color(0xa9a2a2a2),
      backgroundColor: const Color(0xff090909)
    ),
  );
  @override
  Color get fontColor => const Color(0xFFFFFFFF);
  @override
  String get toggleThemeName => Intl.message("lightTheme");
  @override
  IconData get toggleThemeIcon => Icons.light_mode;
  @override
  String get gptLogoPath => PathConstants.chatGPTWhiteImage;
}
