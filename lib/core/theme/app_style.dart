import 'package:flutter/material.dart';

abstract class AppStyle {
  static TextStyle generalBody() {
    return TextStyle(
      color: Colors.black,
    );
  }

  static TextStyle generalSmallSubBody() {
    return TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );
  }

  static TextStyle generalMediumSubBody() {
    return TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );
  }


}

//   static TextStyle redBodyText() {
//     return GoogleFonts.roboto(
//         fontSize: 18,
//         color: Colors.yellow,
//         fontWeight: FontWeight.w700
//     );
//   }
//