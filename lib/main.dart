import 'package:api_project/service/notification_service.dart';
import 'package:api_project/data/data_source/weather_data_source.dart';
import 'package:api_project/presentation/controller/weather_controller.dart';
import 'package:api_project/presentation/view/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    dotenv.load(),
  ]);

  Get.lazyPut(() => WeatherController());
  Get.lazyPut(() => WeatherDataSource());
  Get.lazyPut(() => NotificationService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const WeatherView(),
    );
  }
}

//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _handleNotificationPermission();
//   await LocalNotificationManager.init();
//   tz.initializeTimeZones();
//   runApp(const MyApp());
// }
//
// Future<void> _handleNotificationPermission() async {
//   var permissionStatus = await Permission.notification.status;
//   if (!permissionStatus.isGranted) {
//     bool isGranted = await Permission.notification.request().isGranted;
//     if (!isGranted) {
//       await openAppSettings();
//     }
//   }
// }
