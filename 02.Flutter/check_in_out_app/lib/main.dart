import 'package:flutter/material.dart';
import 'package:check_in_out_app/screens/check_homescreen.dart';

void main() {
  runApp(const SubMainVer00());
}

class SubMainVer00 extends StatelessWidget {
  const SubMainVer00({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple[200],
          )
      ),
      debugShowCheckedModeBanner: false,
      home: const CheckHomescreen(),
    );
  }
}