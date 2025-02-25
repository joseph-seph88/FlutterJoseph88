import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppStyle {
  static TextStyle chatText() {
    return GoogleFonts.roboto(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.w500
    );
  }

  static TextStyle timeText() {
    return GoogleFonts.roboto(
      fontSize: 12,
      color: Colors.grey,
    );
  }
  static TextStyle hintText() {
    return GoogleFonts.roboto(
      fontSize: 15,
      color: Colors.grey,
      fontWeight: FontWeight.w500
    );
  }

  static TextStyle eduText() {
    return GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600
    );
  }

  static TextStyle titleText() {
    return GoogleFonts.roboto(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.w700
    );
  }

  static TextStyle subText() {
    return GoogleFonts.roboto(
        fontSize: 14,
        color: Colors.grey,
        fontWeight: FontWeight.w500
    );
  }

  static TextStyle webText() {
    return GoogleFonts.roboto(
        fontSize: 20,
        color: Colors.black87,
        fontWeight: FontWeight.w500
    );
  }

  static TextStyle webSmallText() {
    return GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w500
    );
  }

  static TextStyle whiteTitleText() {
    return GoogleFonts.roboto(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w700
    );
  }

  static TextStyle whiteSubText() {
    return GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w500
    );
  }

  static TextStyle whiteBodyText() {
    return GoogleFonts.roboto(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w500
    );
  }

  static TextStyle redBodyText() {
    return GoogleFonts.roboto(
        fontSize: 18,
        color: Colors.yellow,
        fontWeight: FontWeight.w700
    );
  }

  static TextStyle blueBodyText() {
    return GoogleFonts.roboto(
        fontSize: 14,
        color: Colors.blue.shade700,
    );
  }
}