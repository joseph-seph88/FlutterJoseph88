import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Expanded Widget Example')),
        body: Center(
          child: Column(
            children: [
              // 여기에 Expanded 위젯 설정
              Text("FVM!"),
              SizedBox(height: 20),
              Text("${dotenv.env['MASTER_NAME']}"),
              SizedBox(height: 20),
              Text("${dotenv.env['API_URL']}"),
            ],
          ),
        ),
      ),
    );
  }
}
