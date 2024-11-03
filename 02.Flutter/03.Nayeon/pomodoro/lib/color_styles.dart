import 'package:flutter/material.dart';

/* 습관의 숲에서 가져온 팔레트를 기준으로 주황색만 추가했습니다.
컬러 호출 시 color : bluestyle1 이런식으로 사용하시면 됩니다.
색마다 3번색을 기준으로 사용하시길 추천하며(강요X)
필요 시 명암조절을 1~6번으로 하시면 좋을 것 같습니다. */

// 기본적인 컬러구성 : blue, yellow, purple, green, mint, orange, pink
// 포인트컬러(추천) : red
// 베이스컬러(추천) : base

const bluestyle1 = Color(0xffd1e6f1);
const bluestyle2 = Color(0xff90c5e8);
const bluestyle3 = Color(0xff73afdc);
const bluestyle4 = Color(0xff539dd1);
const bluestyle5 = Color(0xff2274ac);
const bluestyle6 = Color(0xff015f9f);

const yellowstyle1 = Color(0xfffefcd4);
const yellowstyle2 = Color(0xfffdf29d);
const yellowstyle3 = Color(0xfffde67c); // 추천
const yellowstyle4 = Color(0xffffdd66);
const yellowstyle5 = Color(0xfff0c328);
const yellowstyle6 = Color(0xffe8ac0b); // 추천
const yellowstyle7 = Color.fromARGB(255, 216, 160, 7);

const purplestyle1 = Color(0xffeae1f9);
const purplestyle2 = Color(0xffd5d0f1);
const purplestyle3 = Color(0xffb198de);
const purplestyle4 = Color(0xffb198de);
const purplestyle5 = Color(0xff795db8);
const purplestyle6 = Color(0xff795db8);

const greenstyle1 = Color(0xffe1f8a5);
const greenstyle2 = Color(0xffadc963);
const greenstyle3 = Color(0xff69ab60);
const greenstyle4 = Color(0xff5a8e50);
const greenstyle5 = Color(0xff5a8e50);
const greenstyle6 = Color(0xff2c6b33);

const orangestyle1 = Color(0xfff0dcc9);
const orangestyle2 = Color(0xffe8c5ad);
const orangestyle3 = Color(0xffe3a16a);
const orangestyle4 = Color(0xffe29253);
const orangestyle5 = Color(0xffd57114);

const pinkstyle1 = Color(0xfff2d9d8);
const pinkstyle2 = Color(0xffebc9c7);
const pinkstyle3 = Color(0xffe9a5b0);
const pinkstyle4 = Color(0xffd47a86);
const pinkstyle5 = Color(0xffc7616f);

const mintstyle1 = Color(0xffc6dfdd);
const mintstyle2 = Color(0xffa8d1cf);
const mintstyle3 = Color(0xfface7e7);
const mintstyle4 = Color(0xff77ccd6);
const mintstyle5 = Color(0xff77ccd6);
const mintstyle6 = Color(0xff327b82);

const redstyle1 = Color(0xfff6aeb7);
const redstyle2 = Color(0xfff36770);
const redstyle3 = Color(0xffc02a1f); // point color 추천

const basestyle1 = Color(0xffffffff); // 기본 제공되는 흰색과 같은 색입니다.
const basestyle2 = Color(0xfffff5e1); // 흰색이 아닌 미색이 필요한때 추천
const basestyle3 = Color(0xff101010); // 기본 제공되는 검정색대신 사용해주세요

const MaterialColor yellowstyle = MaterialColor(
  0xfffde67c, // 기본 색상 값
  <int, Color>{
    50: Color(0xfffffee8), // yellowstyle1보다 더 밝은 단계
    100: yellowstyle1, // 기본 밝은 색상
    200: yellowstyle2, // 중간 밝기
    300: Color(0xfffde084), // 추가 밝기 단계
    400: yellowstyle3, // 기본 색상
    500: yellowstyle4, // 중간보다 살짝 어두운 단계
    600: Color(0xfff2c43b), // 추가 어두운 색상
    700: yellowstyle5, // 어두운 단계
    800: Color(0xffe7b30f), // 추가 어두운 색상
    900: yellowstyle6, // 가장 어두운 색상
  },
);
