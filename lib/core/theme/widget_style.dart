import 'package:flutter/material.dart';

class WidgetStyle {
  BoxDecoration imageBackBoxDecoration(String image) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      ),
    );
  }

  BoxDecoration bannerBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withAlpha(180),
        ],
      ),
    );
  }

  BoxDecoration whiteShadowBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(80),
          blurRadius: 20,
          offset: Offset(0, 5),
        ),
      ],
    );
  }

  BoxDecoration white23ShadowBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      color: Colors.indigo.shade50,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(100),
          blurRadius: 2,
          offset: Offset(5, 5),
        ),
      ],
    );
  }

  BoxDecoration blackBasicBoxDecoration() {
    return BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(4),
    );
  }

  BoxDecoration blueCircleBoxDecoration() {
    return BoxDecoration(
      color: Colors.black,
      shape: BoxShape.circle,
    );
  }

  BoxDecoration customBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFFFFDF4),
          Color(0xFFEBE4DE),
          Color(0xFFEBE3DC),
        ],
        stops: [0.0, 0.7, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.deepPurpleAccent.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 3),
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Colors.white,
          blurRadius: 5,
          offset: Offset(-3, -3),
          spreadRadius: 0,
        ),
      ],
      border: Border.all(
        color: Colors.deepPurpleAccent.withOpacity(0.15),
        width: 1.5,
      ),
    );
  }

  BoxDecoration customBoxDecoration2() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color(0xFF020280), width: 1.5),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    );
  }
}
