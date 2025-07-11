import 'package:ai_hair_official/app/app.dart';
import 'package:ai_hair_official/core/locator.dart';
import 'package:flutter/material.dart';

class Bootstrap {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await _initAsyncServices();
      _initSyncServices();
      _runApp();
    } catch (e, stack) {
      debugPrint('Bootstrap Error: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  static Future<void> _initAsyncServices() async {
    debugPrint('Async Services Initialized');
  }

  static void _initSyncServices() {
    setupLocator();
    debugPrint('Sync Services Initialized');
  }

  static void _runApp() {
    runApp(const MyApp());
  }
}
