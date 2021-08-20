import 'package:flutter/material.dart';

class ThemeHelper {
  //copyWith: save all attribute for light that exist inside the code
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    accentColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.green,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.blue,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black,
    accentColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.orange,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
