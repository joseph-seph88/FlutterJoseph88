import 'package:flutter/material.dart';
import 'app_style.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData.light(useMaterial3: true).copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Colors.green,
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade50
          )),
      popupMenuTheme: PopupMenuThemeData(color: Colors.green.shade50),
      floatingActionButtonTheme: FloatingActionButtonThemeData(),
      appBarTheme: AppBarTheme(),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(color: Colors.white),
        subtitleTextStyle: TextStyle(color: Colors.grey),
        tileColor: Colors.blueAccent,
        selectedTileColor: Colors.deepPurple,
        iconColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30))),
        // color: Colors.white,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(30))),
        margin: EdgeInsets.all(10),
      ),
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.green),
          ),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: const BorderSide(color: Colors.deepPurple),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: const BorderSide(color: Colors.black),
          // ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      textTheme: TextTheme(
        // titleLarge: AppStyle.chatText(),
        // titleMedium: AppStyle.chatText(),
        bodyLarge: AppStyle.generalText(),
        bodyMedium: AppStyle.generalText(),
        // labelLarge:AppStyle.chatText() ,
        // labelMedium: AppStyle.chatText(),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // 다크 테마 스타일 설정
    );
  }
}