import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/permission_manager.dart';
import 'package:o2/data/datasources/product_data_source.dart';
import 'package:o2/data/repositories/product_repository_impl.dart';
import 'package:o2/firebase_options.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // flutter_image_compress 초기화
  FlutterImageCompress.validator.ignoreCheckExtName = true;

  await Future.wait([
    NaverMapSdk.instance.initialize(),
    PermissionManager().requestLocationPermission(),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);

  // 더미 데이터 업로드
  // await uploadDummyData();

  runApp(
    ProviderScope(
      overrides: [
        productRepositoryProvider.overrideWithValue(
          ProductRepositoryImpl(ProductDataSource()),
        ),
      ],
      child: const MyApp(),
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

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light(),
    );
  }
}
