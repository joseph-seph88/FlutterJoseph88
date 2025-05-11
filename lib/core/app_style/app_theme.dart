import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color.fromARGB(255, 112, 58, 187);
  static const subPrimary = Color.fromARGB(255, 120, 92, 159);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const black = Color.fromARGB(0, 0, 0, 0);
  static const grey = Color.fromARGB(255, 127, 127, 127);

  static const Color primaryColor = Color(0xFFFF8A3D);
  static const Color secondaryColor = Color(0xFF333333);
  static const Color backgroundColor = Color(0xFFF7F7F7);
  static const Color textColor = Color(0xFF333333);
  static const Color greyColor = Color(0xFFAAAAAA);
  static const Color dividerColor = Color(0xFFEEEEEE);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
          color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textColor,
        fontSize: 14,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
}
