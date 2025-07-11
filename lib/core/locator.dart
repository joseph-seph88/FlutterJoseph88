import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_hair_official/core/api_client.dart';
import 'package:ai_hair_official/features/hair/hair_di/setup_hair_di.dart';

final getIt = GetIt.instance;

void setupLocator() {
  _setupCoreDependencies();
  _setupFeatureDependencies();
}

void _setupCoreDependencies() {
  getIt.registerLazySingleton<Dio>(() {
    final baseUrl = "http://localhost:3000";
    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
    );
    final dio = Dio(baseOptions);
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
    return dio;
  });

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));
}

void _setupFeatureDependencies() {
  setupHairDi(getIt);
}