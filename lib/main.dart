import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isTap1 = false;
  bool isTap2 = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Expanded Widget Example')),
        body: Center(
          child: Column(
            children: [
              Text("GITHUB ACTIONS TEST"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isTap1 = true;
                  });
                },
                child: Text('name button'),
              ),
              Text(isTap1 == true ? "${dotenv.env['MASTER_NAME']}" : "no name"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isTap2 = true;
                  });
                },
                child: Text('url button'),
              ),
              Text(isTap2 == true ? "${dotenv.env['API_URL']}" : "no url"),
            ],
          ),
        ),
      ),
    );
  }
}
