import 'package:flutter/material.dart';

abstract class AppStyle {
  static TextStyle generalText() {
    return TextStyle(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.w500
    );
  }

  static TextStyle blackTitle(){
    return TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w700,
        letterSpacing: 8
    );
  }

  static TextStyle blackMediumTitle(){
    return TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5
    );
  }

  static TextStyle indigoBigBody(){
    return TextStyle(
      fontSize: 32,
      color: Colors.indigo.shade900,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle blueGreyMediumBody(){
    return TextStyle(
      fontSize: 17,
      color: Colors.blueGrey,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle blueGraySmallMediumBody(){
    return TextStyle(
      fontSize: 16,
      color: Colors.blueGrey,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle blueGraySmallBody(){
    return TextStyle(
      fontSize: 14,
      color: Colors.blueGrey,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle blackMediumBody(){
    return TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle black87SmallMediumBody(){
    return TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
    );
  }


  static TextStyle blackSmallMediumBody(){
    return TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle blackSmallBody(){
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle greySmallBody(){
    return TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontWeight: FontWeight.w600,
    );
  }

  static TextStyle greyMediumBody(){
    return TextStyle(
      fontSize: 17,
      color: Colors.grey,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle greyVerySmallBody(){
    return TextStyle(
      fontSize: 12,
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle whiteVerySmallBody(){
    return TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle whiteMediumTitle(){
    return TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5
    );
  }

  static TextStyle whiteSmallBody(){
    return TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500,
    );
  }




  static TextStyle whiteSubTitle(){
    return TextStyle(
        fontSize: 14,
        color: Colors.white70,
        fontWeight: FontWeight.w500,
    );
  }
}