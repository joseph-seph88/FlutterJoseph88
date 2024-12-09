import 'package:class_10_firebase/screens/login_screen.dart';
import 'package:class_10_firebase/screens/main_screen.dart';
import 'package:flutter/material.dart';


// import 'package:class_10_firebase/my_app.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
//
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const ProviderScope(child: MyApp()));
// }


class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: LoginScreen(),
    );
  }
}
