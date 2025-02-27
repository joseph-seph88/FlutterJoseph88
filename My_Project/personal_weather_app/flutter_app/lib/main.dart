import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/domain/usecase/weather_useCase.dart';
import 'package:flutter_app/presentation/controller/weather_controller.dart';
import 'package:flutter_app/presentation/view/weather_view.dart';
import 'package:flutter_app/service/notification_service.dart';
import 'package:flutter_app/service/websocket_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'data/data_source/weather_data_source.dart';
import 'data/repository/weather_repository_impl.dart';
import 'domain/repository/weather_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    dotenv.load(),
  ]);

  Get.lazyPut(() => WeatherController());
  Get.lazyPut(() => WeatherDataSource());
  Get.lazyPut(() => NotificationService());
  Get.lazyPut(() => WebsocketService());
  Get.lazyPut<WeatherRepository>(() => WeatherRepositoryImpl(Get.find<WeatherDataSource>()));
  Get.lazyPut(() => WeatherUseCase(Get.find<WeatherRepository>()));



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