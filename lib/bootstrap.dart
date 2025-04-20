import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_login/app.dart';
import 'package:project_login/feature/auth/cubit/login_cubit.dart';
import 'package:project_login/feature/auth/presentation/pages/login_page.dart';

class Bootstrap {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await _initServices();
      _runApp();
    } catch (e, stack) {
      debugPrint('Bootstrap Error: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  static Future<void> _initServices() async {
    // await Firebase.initializeApp();
    // await dotenv.load(fileName: '.env');
    // final prefs = await SharedPreferences.getInstance();
    // await LocalDatabase.init();
    debugPrint('Services Initialized');
  }

  static void _runApp() {
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(
            create: (_) => LoginCubit(),
            child: LoginPage(),
          ),
          // BlocProvider<ThemeCubit>(
          //   create: (_) => ThemeCubit(),
          // ),
        ],
        child: const MyApp(),
      ),
    );
  }
}
