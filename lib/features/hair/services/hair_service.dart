import 'dart:io';
import 'package:ai_hair_official/core/api_client.dart';
import 'package:ai_hair_official/core/api_error.dart';
import 'package:ai_hair_official/core/api_response.dart';
import 'package:ai_hair_official/features/models/hair_response.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class HairService {
  final ApiClient _apiClient;

  HairService(this._apiClient);

  Future<Either<ApiError, ApiResponse<HairResponse>>> manipulationHairStyle(
    File userImage,
    File otherImage,
    String userId,
    String colorId,
  ) async {
    final formData = FormData.fromMap({
      'userId': userId,
      'colorId': colorId,
      'files': [
        await MultipartFile.fromFile(userImage.path),
        await MultipartFile.fromFile(otherImage.path),
      ],
    });

    return await _apiClient.post<HairResponse>(
      '/hair/manipulation-image',
      (json) => HairResponse.fromJson(json as Map<String, dynamic>),
      data: formData,
    );
  }

  Future<Either<ApiError, ApiResponse<HairResponse>>> recommandHairStyle(
    File userImage,
    String userId,
    String colorId,
  ) async {
    final formData = FormData.fromMap({
      'userId': userId,
      'colorId': colorId,
      'file': await MultipartFile.fromFile(userImage.path),
    });

    return await _apiClient.post<HairResponse>(
      '/hair/recommand-image',
      (json) => HairResponse.fromJson(json as Map<String, dynamic>),
      data: formData,
    );
  }
}
