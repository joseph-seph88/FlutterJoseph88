import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData.light(useMaterial3: true).copyWith(
      primaryColor: Colors.blue,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50)),
      popupMenuTheme: PopupMenuThemeData(color: Colors.blue.shade50),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(),
      appBarTheme: const AppBarTheme(),
      listTileTheme: ListTileThemeData(
        titleTextStyle: const TextStyle(color: Colors.white),
        subtitleTextStyle: const TextStyle(color: Colors.grey),
        tileColor: Colors.blueAccent,
        selectedTileColor: Colors.deepPurple,
        iconColor: Colors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        // color: Colors.white,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(30))),
        margin: EdgeInsets.all(10),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(12),
        //   borderSide: const BorderSide(color: Colors.deepPurple),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(12),
        //   borderSide: const BorderSide(color: Colors.black),
        // ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      textTheme: TextTheme(
          // titleLarge: AppStyle.chatText(),
          // titleMedium: AppStyle.chatText(),
          // bodyLarge: AppStyle.chatText(),
          // bodyMedium: AppStyle.chatText(),
          // labelLarge:AppStyle.chatText() ,
          // labelMedium: AppStyle.chatText(),
          ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey,
      // 다크 테마 스타일 설정
    );
  }
}
