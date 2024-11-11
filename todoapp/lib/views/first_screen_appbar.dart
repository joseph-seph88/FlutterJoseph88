import 'package:flutter/material.dart';

class FirstScreenAppbar extends StatelessWidget implements PreferredSizeWidget {
  const FirstScreenAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 28),
        child: Text(
          'TO DO LIST',
          style: TextStyle(
              color: Colors.deepPurple[300],
              fontWeight: FontWeight.bold,
              fontSize: 38),
        ),
      ),
      centerTitle: true,
    );
  }

}
