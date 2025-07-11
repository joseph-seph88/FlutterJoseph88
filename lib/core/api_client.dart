import 'package:ai_hair_official/core/api_error.dart';
import 'package:ai_hair_official/core/api_response.dart';
import 'package:ai_hair_official/core/utils/either_util.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Either<ApiError, ApiResponse<T>>> get<T>(
    String path,
    T Function(dynamic) fromData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse<T>(
        res,
        fromData,
      );
    } catch (e, s) {
      return handleError(e, s);
    }
  }

  Future<Either<ApiError, ApiResponse<T>>> post<T>(
    String path,
    T Function(dynamic) fromData, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse<T>(
        res,
        fromData,
      );
    } catch (e, s) {
      return handleError(e, s);
    }
  }

  Future<Either<ApiError, ApiResponse<T>>> put<T>(
    String path,
    T Function(dynamic) fromData, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse<T>(
        res,
        fromData,
      );
    } catch (e, s) {
      return handleError(e, s);
    }
  }

  Future<Either<ApiError, ApiResponse<T>>> delete<T>(
    String path,
    T Function(dynamic) fromData, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return handleResponse<T>(
        res,
        fromData,
      );
    } catch (e, s) {
      return handleError(e, s);
    }
  }
}
