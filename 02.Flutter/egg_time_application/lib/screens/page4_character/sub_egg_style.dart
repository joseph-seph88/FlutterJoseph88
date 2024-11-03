import 'package:flutter/material.dart';

class SubEggStyle extends StatelessWidget {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double angle;
  final String imagePath = 'assets/img/egg03.png';

  const SubEggStyle({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.angle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Transform.rotate(
        angle: angle,
        child: Image.asset(
          imagePath,
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}