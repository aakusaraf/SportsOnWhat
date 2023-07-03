import 'package:flutter/material.dart';
import '../helpers/DarkThemePreference.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool isdark = false;


  DarkThemeProvider()
  {
    getdarkTheme();
  }
  getdarkTheme() async
  {
    isdark = await darkThemePreference.getTheme();
  }

  set darkTheme(bool value) {
    isdark = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}