import 'package:flutter/material.dart';
import 'package:untitled/adminSection/utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _primaryColor = Palette.white;
  Color _scaffoldBackgroundColor = Palette.white;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Color get primaryColor => _primaryColor;

  Color get scaffoldBackgroundColor => _scaffoldBackgroundColor;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _updateAppBasicColorsColor();

    notifyListeners();
  }

  void _updateAppBasicColorsColor() {
    _primaryColor = isDarkMode ? Palette.white : Palette.black;
    _scaffoldBackgroundColor = isDarkMode ? Palette.black : Palette.white;
  }
}
