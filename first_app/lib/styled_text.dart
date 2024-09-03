import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText({super.key});

  @override
  Widget build(context) {
    return Text(
      'Welcom, Master!',
      style: TextStyle(
        color: const Color.fromARGB(255, 143, 159, 143),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
