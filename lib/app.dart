import 'package:flutter/material.dart';
import 'package:project_login/feature/auth/presentation/pages/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6200EE),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF6200EE),
          secondary: const Color(0xFF03DAC6),
        ),
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => const Scaffold(
              body: Center(child: Text('로그인 성공! 홈 화면입니다.')),
            ),
      },
    );
  }
}
