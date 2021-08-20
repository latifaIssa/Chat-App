import 'package:chat_app/services/theme_helper.dart';
import 'package:flutter/material.dart';

enum MyThemeMode { dark, light }

class ThemeProvider extends ChangeNotifier {
  ThemeData themeData = ThemeHelper.lightTheme;
  setThemeData(MyThemeMode mode) {
    themeData = (mode == MyThemeMode.light)
        ? ThemeHelper.lightTheme
        : ThemeHelper.darkTheme;
    notifyListeners();
  }
}
