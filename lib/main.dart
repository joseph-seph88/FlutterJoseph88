import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:o2/core/services/fcm_service.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/permission_manager.dart';
import 'package:o2/firebase_options.dart';
import 'package:o2/presentation/providers/route_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load();

  // flutter_image_compress 초기화
  FlutterImageCompress.validator.ignoreCheckExtName = true;

  await Future.wait([
    NaverMapSdk.instance.initialize(),
    PermissionManager().requestLocationPermission(),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);

  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_KEY'] ?? '');

  final prefs = await SharedPreferences.getInstance();
  final notificationEnabled = prefs.getBool('notificationEnabled') ?? true;
  if (notificationEnabled) {
    await FCMService().initialize();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light(),
    );
  }
}
