import 'package:ai_hair_official/core/api_error.dart';
import 'package:ai_hair_official/core/api_response.dart';
// import 'package:ai_hair_official/core/utils/logger_util.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

Either<ApiError, T> handleError<T>(
  Object e,
  StackTrace s,
) {
  // logger.e('$e\n$s');
  if (e is DioException) {
    return Left(_handleDioException(e));
  }
  return Left(ApiError(message: e.toString(), statusCode: 500));
}

ApiError _handleDioException(DioException e) {
  final String message;
  final int statusCode;

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      message = '요청 시간이 초과되었습니다.';
      statusCode = 408;
      break;
    case DioExceptionType.badResponse:
      final dynamic rawData = e.response?.data;
      String serverMessage = '알 수 없는 서버 오류입니다.';

      if (rawData is Map && rawData.containsKey('message')) {
        serverMessage = rawData['message'];
      } else if (rawData is String && rawData.isNotEmpty) {
        serverMessage = rawData;
      } else if (e.response?.statusMessage?.isNotEmpty ?? false) {
        serverMessage = e.response!.statusMessage!;
      }
      message = serverMessage;
      statusCode = e.response?.statusCode ?? 500;
      break;
    case DioExceptionType.cancel:
      message = '요청이 취소되었습니다.';
      statusCode = 499;
      break;
    case DioExceptionType.connectionError:
      message = '네트워크 연결을 확인해주세요.';
      statusCode = 503;
      break;
    case DioExceptionType.unknown:
    default:
      message = e.message ?? '알 수 없는 오류가 발생했습니다.';
      statusCode = e.response?.statusCode ?? 500;
      break;
  }

  return ApiError(message: message, statusCode: statusCode);
}

Either<ApiError, ApiResponse<T>> handleResponse<T>(
  Response res,
  T Function(dynamic) fromData,
) {
  final code = res.statusCode ?? 500;

  if (code < 200 || code >= 300) {
    String message = 'Unknown server response : $code error';
    final data = res.data;
    if (data is Map && data.containsKey('message')) {
      message = data['message'];
    } else if (data is String && data.isNotEmpty) {
      message = data;
    } else if (res.statusMessage != null && res.statusMessage!.isNotEmpty) {
      message = res.statusMessage!;
    }
    return Left(ApiError(message: message, statusCode: code));
  }

  if (res.data == null) {
    return Left(ApiError(message: 'Response body is null', statusCode: code));
  }

  try {
    final data = res.data;
    if (data is List) {
      final parsed = fromData(data);
      return Right(ApiResponse<T>(
        statusCode: code,
        message: 'Success',
        data: parsed,
      ));
    }
    if (data is Map<String, dynamic>) {
      if (data.containsKey('statusCode') &&
          data.containsKey('message') &&
          data.containsKey('data')) {
        return Right(ApiResponse<T>(
          statusCode: data['statusCode'] as int,
          message: data['message'] as String,
          data: data['data'] != null ? fromData(data['data']) : null,
        ));
      } else {
        final parsed = fromData(data);
        return Right(ApiResponse<T>(
          statusCode: code,
          message: 'Success',
          data: parsed,
        ));
      }
    }
    throw Exception(
        '[HANDLE_RESPONSE] Unexpected data type: ${data.runtimeType} // value: $data');
  } catch (e) {
    return Left(ApiError(message: 'Data parsing error: $e', statusCode: code));
  }
}
