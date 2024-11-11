import 'package:flutter/material.dart';
import 'package:todoapp/views/first_screen_appbar.dart';
import 'package:todoapp/views/first_screen_list_builder.dart';
import 'package:todoapp/views/first_screen_textField.dart';
import 'package:todoapp/views/second_screen.dart';

class FirstScreen extends StatelessWidget implements PreferredSizeWidget {
  const FirstScreen({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FirstScreenAppbar(),
      body: PageView(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 80),
                FirstScreenTextField(),
                const SizedBox(height: 28),
                const FirstScreenListBuilder(),
              ],
            ),
          ),
          const SecondScreen(),
        ],
      ),
    );
  }
}
