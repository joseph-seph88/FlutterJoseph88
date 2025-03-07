import 'package:flutter/material.dart';

abstract class AppStyle {
  // Black
  static TextStyle generalBody() {
    return TextStyle(
      color: Colors.black,
    );
  }

  static TextStyle generalLargeBody() {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }

  static TextStyle generalLargeTitle() {
    return TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 3);
  }

  // Grey
  static TextStyle generalSmallSubBody() {
    return TextStyle(
      color: Colors.grey[600],
      fontSize: 12,
    );
  }

  static TextStyle generalSmallMediumSubBody() {
    return TextStyle(
      color: Colors.grey[600],
      fontSize: 14,
    );
  }

  static TextStyle generalMediumSubBody() {
    return TextStyle(
      fontSize: 16,
      color: Colors.grey[600],
    );
  }

  static TextStyle generalLargeSubBody() {
    return TextStyle(
        fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500);
  }

  // White
  static TextStyle generalWhiteLargeBody() {
    return TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 3);
  }

  static TextStyle generalWhiteMediumBody() {
    return TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 1);
  }

  static TextStyle generalWhite70SubBody() {
    return TextStyle(
      color: Colors.white70,
    );
  }

  static TextStyle generalWhiteSmallLabel() {
    return TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
  }

  // Pink
  static TextStyle pinkLargeMainBody() {
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.pink,
      letterSpacing: 5,
    );
  }

  static TextStyle pinkSmallBody() {
    return TextStyle(
      fontSize: 18,
      color: Colors.deepPurple[300],
    );
  }

  static TextStyle pinkMediumLabel() {
    return TextStyle(
      fontSize: 16,
      color: Colors.pink,
      letterSpacing: 2,
    );
  }

  // Red
  static TextStyle imageErrorBody() {
    return TextStyle(
        fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFFF4D67));
  }

  static TextStyle purpleSmallBoldBody() {
    return TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple[300]);
  }

  // Dynamic
  static TextStyle dynamicWhiteMediumLabel(bool isSelected) {
    return TextStyle(
      color: isSelected ? Colors.white : Colors.grey.shade800,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      fontSize: 14,
    );
  }

  static TextStyle dynamicRedSmallLabel(bool isSelected) {
    return TextStyle(
      color: isSelected ? Color(0xFFFF4D67) : Colors.grey.shade600,
      fontSize: 12,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );
  }
}
