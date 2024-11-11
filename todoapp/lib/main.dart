import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/view_model/view_model.dart';
import 'package:todoapp/view_model/view_model_animation.dart';

import 'package:todoapp/views/first_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ToDoViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ViewModelAnimation(),
        ),
      ],
      child: const MyApp88(),
    ),
  );
}

class MyApp88 extends StatelessWidget {
  const MyApp88({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.deepPurple[100],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepPurple[100],
          )),
      home: const FirstScreen(),
    );
  }
}
