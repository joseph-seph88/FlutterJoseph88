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

  static TextStyle imageErrorBody() {
    return TextStyle(
        fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFFF4D67));
  }

  static TextStyle generalLargeBody(){
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }

  static TextStyle generalWhiteLargeBody(){
    return TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w600,
    );
  }

  static TextStyle generalWhite70SubBody(){
    return TextStyle(
      color: Colors.white70,
    );
  }

  static TextStyle generalWhiteSmallLabel(){
    return TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
  }

  static TextStyle dynamicWhiteMediumLabel(bool isSelected){
    return TextStyle(
      color: isSelected ? Colors.white : Colors.grey.shade800,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      fontSize: 14,
    );
  }

  static TextStyle dynamicRedSmallLabel(bool isSelected){
    return TextStyle(
      color: isSelected ? Color(0xFFFF4D67) : Colors.grey.shade600,
      fontSize: 12,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );
  }

}
