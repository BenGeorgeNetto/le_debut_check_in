import 'package:flutter/material.dart';
import 'package:le_debut_check_in/text_theme.dart';

import 'colors.dart';

class MyDarkThemeStyle {
  static ThemeData myDarkMode = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: voidColor,
    appBarTheme: const AppBarTheme(
      color: Colors.black12,
      elevation: 4.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.black12,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
    ),
    textTheme: customTextTheme,
  );
}
