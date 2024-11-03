import 'package:flutter/material.dart';
import 'package:egg_time_application/common/color_styles.dart';

class DescriptionPage extends StatelessWidget {
  final String description;

  const DescriptionPage({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Character Description",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            description,
            style: TextStyle(
              fontSize: 34,
              fontFamily: 'font1',
              fontWeight: FontWeight.bold,
              color: EggColors().purplestyle6,
            ),
          ),
        ),
      ),
    );
  }
}
