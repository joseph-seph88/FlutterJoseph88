import 'package:flutter/material.dart';
import 'color_styles.dart';

TextStyle getYellowOutlineTextStyle(double fontSize) {
  return TextStyle(
    fontFamily: 'Hyemin_Bold',
    fontSize: fontSize,
    color: EggColors().yellowstyle6, // 내부 텍스트 색상
    shadows: [
      Shadow(offset: const Offset(-1.5, -1.5), color: EggColors().basestyle2),
      Shadow(offset: const Offset(1.5, -1.5), color: EggColors().basestyle2),
      Shadow(offset: const Offset(1.5, 1.5), color: EggColors().basestyle2),
      Shadow(offset: const Offset(-1.5, 1.5), color: EggColors().basestyle2),
    ],
  );
}
