import 'package:flutter/material.dart';

/* 습관의 숲에서 가져온 팔레트를 기준으로 주황색만 추가했습니다.
컬러 호출 시 Color.bluestyle1 이런식으로 사용하시면 됩니다.
색마다 3번색을 기준으로 사용하시길 추천하며, 
필요 시 명암조절을 1~6번으로 하시면 좋을 것 같습니다. */

// 기본적인 컬러구성 : blue, yellow, purple, green, mint, orange, pink
// 포인트컬러 : red
// 배경색 : base
class EggColors {
  final bluestyle1 = const Color(0xffd1e6f1);
  final bluestyle2 = const Color(0xff90c5e8);
  final bluestyle3 = const Color(0xff73afdc);
  final bluestyle4 = const Color(0xff539dd1);
  final bluestyle5 = const Color(0xff2274ac);
  final bluestyle6 = const Color(0xff015f9f);

  final yellowstyle1 = const Color(0xfffefcd4);
  final yellowstyle2 = const Color(0xfffdf29d);
  final yellowstyle3 = const Color(0xfffde67c); // 추천
  final yellowstyle4 = const Color(0xffffdd66);
  final yellowstyle5 = const Color(0xfff0c328);
  final yellowstyle6 = const Color(0xffe8ac0b); // 추천

  final purplestyle1 = const Color(0xffeae1f9);
  final purplestyle2 = const Color(0xffd5d0f1);
  final purplestyle3 = const Color(0xffb198de);
  final purplestyle4 = const Color(0xffb198de);
  final purplestyle5 = const Color(0xff795db8);
  final purplestyle6 = const Color(0xff795db8);

  final greenstyle1 = const Color(0xffe1f8a5);
  final greenstyle2 = const Color(0xffadc963);
  final greenstyle3 = const Color(0xff69ab60);
  final greenstyle4 = const Color(0xff5a8e50);
  final greenstyle5 = const Color(0xff5a8e50);
  final greenstyle6 = const Color(0xff2c6b33);

  final orangestyle1 = const Color(0xfff0dcc9);
  final orangestyle2 = const Color(0xffe8c5ad);
  final orangestyle3 = const Color(0xffe3a16a);
  final orangestyle4 = const Color(0xffe29253);
  final orangestyle5 = const Color(0xffd57114);
  final yellowstyle7 = const Color.fromARGB(255, 216, 160, 7);

  final pinkstyle1 = const Color(0xfff2d9d8);
  final pinkstyle2 = const Color(0xffebc9c7);
  final pinkstyle3 = const Color(0xffe9a5b0);
  final pinkstyle4 = const Color(0xffd47a86);
  final pinkstyle5 = const Color(0xffc7616f);

  final mintstyle1 = const Color(0xffc6dfdd);
  final mintstyle2 = const Color(0xffa8d1cf);
  final mintstyle3 = const Color(0xfface7e7);
  final mintstyle4 = const Color(0xff77ccd6);
  final mintstyle5 = const Color(0xff77ccd6);
  final mintstyle6 = const Color(0xff327b82);

  final redstyle1 = const Color(0xfff6aeb7);
  final redstyle2 = const Color(0xfff36770);
  final redstyle3 = const Color(0xffc02a1f); //point color 추천

  final basestyle1 = const Color(0xffffffff); //기본 제공되는 흰색과 같은 색입니다.
  final basestyle2 = const Color(0xfffff5e1); //흰색이 아닌 미색이 필요한때 추천
  final basestyle3 = const Color(0xff101010); //기본 제공되는 검정색대신 사용해주세요
}

final MaterialColor yellowstyle = MaterialColor(
  0xfffde67c, // 기본 색상 값
  <int, Color>{
    50: const Color(0xfffffee8), // yellowstyle1보다 더 밝은 단계
    100: EggColors().yellowstyle1, // 기본 밝은 색상
    200: EggColors().yellowstyle2, // 중간 밝기
    300: const Color(0xfffde084), // 추가 밝기 단계
    400: EggColors().yellowstyle3, // 기본 색상
    500: EggColors().yellowstyle4, // 중간보다 살짝 어두운 단계
    600: const Color(0xfff2c43b), // 추가 어두운 색상
    700: EggColors().yellowstyle5, // 어두운 단계
    800: const Color(0xffe7b30f), // 추가 어두운 색상
    900: EggColors().yellowstyle6, // 가장 어두운 색상
  },
);
