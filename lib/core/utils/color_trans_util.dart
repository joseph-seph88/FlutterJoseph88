import 'package:flutter/material.dart';

class ColorTransUtil {
  static final Map<String, Color> _colorMap = {
    'brownColor': Colors.brown,
    'orangeColor': Colors.orange,
    'indigoColor': Colors.indigo,
    'lightGreenColor': Colors.lightGreen,
    'deepPurpleColor': Colors.deepPurple,
  };

  static Color transStringToColor(String colorString) {
    return _colorMap[colorString] ?? Colors.black;
  }
}