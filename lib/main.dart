import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web_project/core/app_theme.dart';
import 'package:web_project/data/firebase_data_source.dart';
import 'package:web_project/data/schedule_repository.dart';
import 'package:web_project/presentation/controller/schedule_controller.dart';
import 'package:web_project/presentation/view/new_schedule_view.dart';
import 'domain/schedule_use_case.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut(()=>ScheduleController());
  Get.lazyPut(()=>FirebaseDataSource());
  Get.lazyPut<ScheduleRepository>(() => ScheduleRepositoryImpl(Get.find<FirebaseDataSource>()));
  Get.lazyPut<ScheduleUseCase>(() => ScheduleUseCaseImpl(Get.find<ScheduleRepository>()));

  await Future.wait([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);

  runApp(MyApp());
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
      // darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: NewScheduleView(),
    );
  }
}
