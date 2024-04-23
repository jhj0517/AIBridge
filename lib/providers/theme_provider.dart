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
  final SharedPreferences prefs;
  final initialTheme = ThemeModes.light;

  ThemeProvider({
    required this.prefs
  }){
    _loadTheme();
  }

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
    ThemeModes mode = modeIndex == null ? initialTheme : ThemeModes.values[modeIndex];
    _attrs = mode == ThemeModes.light ? LightThemeAttributes() : DarkThemeAttributes();
  }

  Future<void> _saveTheme() async {
    prefs.setInt(SharedPreferenceConstants.theme, attrs.mode.index);
  }

}

abstract class ThemeAttributes {
  ThemeModes get mode;
  ThemeData get themeData;
  Color get fontColor;
  Color get navigationBackgroundColor;
  Color get selectedNavigationItemColor;
  Color get unSelectedNavigationItemColor;
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
    )
  );
  @override
  Color get fontColor => const Color(0xFF000000);
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
      appBarTheme: const AppBarTheme().copyWith(
      )
  );
  @override
  Color get fontColor => const Color(0xFFFFFFFF);
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
