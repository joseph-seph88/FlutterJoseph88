import 'package:flutter/material.dart';
import 'character_firstpage.dart';

class CharacterMainHomepage extends StatefulWidget {
  const CharacterMainHomepage({super.key});

  @override
  State<CharacterMainHomepage> createState() => _CharacterMainHomepageState();
}

class _CharacterMainHomepageState extends State<CharacterMainHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: const Text(
          'Egg Pomo',
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            fontFamily: 'font1',
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onDoubleTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CharacterFirstpage(),
              ),
            );
          },
          child: Image.asset(
            'assets/img/egg06.png',
            width: 400,
            height: 400,
          ),
        ),
      ),
    );
  }
}
