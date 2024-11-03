import 'package:flutter/material.dart';
import 'colors_style.dart';

class FirstCardVer02 extends StatefulWidget {
  const FirstCardVer02({super.key});

  @override
  State<FirstCardVer02> createState() => _FirstCardVer02State();
}

class _FirstCardVer02State extends State<FirstCardVer02> {
  List<String> data = ['HP', 'EXP', 'STA', '??'];
  List<String> data2 = ['100', '0.0', 'ZZ..Z', ''];
  List<IconData> icons = [
    Icons.science_outlined,
    Icons.grass_outlined,
    Icons.person_search,
    Icons.adb_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            margin: const EdgeInsets.only(bottom: 28),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [ColorsStyle.purplestyle1, ColorsStyle.purplestyle2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColorsStyle.purplestyle3.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icons[index],
                      size: 26,
                      color: ColorsStyle.purplestyle6,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data[index],
                          style: const TextStyle(
                            fontSize: 32,
                            color: ColorsStyle.purplestyle3,
                            fontFamily: 'font1',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          data2[index],
                          style: TextStyle(
                            fontSize: 32,
                            color: ColorsStyle.purplestyle5,
                            fontFamily: 'font1',
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: const Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
