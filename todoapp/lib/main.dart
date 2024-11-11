import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/screens/todo_screen_01.dart';
import 'package:todoapp/view/view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ToDoViewModel()),
      ],
      child: const MyApp88(),
    ),
  );
}


class MyApp88 extends StatelessWidget {
  const MyApp88({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:TodoScreen01());
  }
}
