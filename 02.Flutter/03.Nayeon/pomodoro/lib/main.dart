import 'package:flutter/material.dart';
import 'package:pomodoro/color_styles.dart';
import 'package:pomodoro/pomodoro_timer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro App',
      theme: ThemeData(
        fontFamily: 'Hyemin_Bold',
        primarySwatch: yellowstyle,
      ),
      home: PomodoroTimerScreen(),
    );
  }
}
