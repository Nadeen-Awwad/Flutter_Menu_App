import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      _locale = Locale('ar');
    } else {
      _locale = Locale('en');
    }
    notifyListeners();
  }
}
