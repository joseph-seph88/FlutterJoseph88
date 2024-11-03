import 'package:flutter/material.dart';
import 'detail_description.dart';
import 'first_card_ver_02.dart';
import 'colors_style.dart';
import 'character.dart';
class CharacterFirstpage extends StatefulWidget {
  const CharacterFirstpage({super.key});

  @override
  State<CharacterFirstpage> createState() => _CharacterFirstpageState();
}

class _CharacterFirstpageState extends State<CharacterFirstpage> {
  final randomItem = ImageTextManager().getRandomImageText();
  bool _isCardVisible = false;
  int expCount = 0;
  int eatCount = 0;

  void _toggleCardVisibility() {
    setState(() {
      _isCardVisible = !_isCardVisible;
    });
  }

  void _expCountButton() {
    setState(() {
      expCount += 1;
    });
  }
  void _eatCountButton() {
    setState(() {
      eatCount += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          'My!! Char..',
          style: TextStyle(
            fontFamily: 'font1',
            fontWeight: FontWeight.bold,
            fontSize: 54,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isCardVisible)
              Column(
                children: [
                  Text(
                    randomItem.text,
                    style: const TextStyle(
                        fontSize: 28, color: ColorsStyle.purplestyle6),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          final randomItem =
                          ImageTextManager().getRandomImageText();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DescriptionPage(
                                  description: randomItem.detail),
                            ),
                          );
                        },
                        icon: const Icon(Icons.adb_rounded),
                        color: ColorsStyle.purplestyle6,
                      ),
                      IconButton(
                        onPressed: _expCountButton,
                        icon: const Icon(Icons.add),
                        color: ColorsStyle.purplestyle6,
                      ),
                      IconButton(
                        onPressed: _eatCountButton,
                        icon: const Icon(Icons.access_alarm),
                        color: ColorsStyle.purplestyle6,
                      ),
                    ],
                  ),
                ],
              ),
            if (_isCardVisible)
              Text(
                'LV.${randomItem.level} ${randomItem.name}',
                style: const TextStyle(
                    fontSize: 28, color: ColorsStyle.purplestyle6),
              ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _toggleCardVisibility,
              child: Container(
                height: _isCardVisible ? 300 : 500,
                color: Colors.transparent,
                child: Image.asset(
                  randomItem.imagePath,
                  width: 500,
                  height: 500,
                ),
              ),
            ),
            if (_isCardVisible) const FirstCardVer02(),
          ],
        ),
      ),
    );
  }
}
