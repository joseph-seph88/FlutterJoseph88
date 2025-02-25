import 'package:chatbots/data/data_sources/chat_mock_data_source.dart';
import 'package:chatbots/presentation/controller/tf_chat_view_controller.dart';
import 'package:chatbots/presentation/view/tf_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';


void main() async {
  Gemini.init(apiKey: apiKey);
  Get.lazyPut(() => ChatMockDataSource());
  Get.lazyPut(() => TfChatViewController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return GetMaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const TfChatView(),
    );
  }
}
