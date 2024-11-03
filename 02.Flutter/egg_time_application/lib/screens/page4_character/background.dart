import 'package:flutter/material.dart';
import 'sub_egg_style.dart';

class BackgroundEggStyle extends StatelessWidget {
  const BackgroundEggStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(10, (index) {
          return SubEggStyle(
            left: 50.0 * index,
            top: 100.0,
            angle: 0.1 * index,
          );
        }),
      ),
    );
  }
}