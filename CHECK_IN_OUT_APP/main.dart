import 'package:check_app_ver02/CHECK_IN_OUT_APP/screens/check_homescreen.dart';
import 'package:flutter/material.dart';

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