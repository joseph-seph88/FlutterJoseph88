import 'dart:io';
import 'package:ai_hair_official/features/hair/services/hair_service.dart';
import 'package:ai_hair_official/features/hair/presentation/cubits/hair_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_hair_official/core/utils/logger_util.dart';

class HairCubit extends Cubit<HairState> {
  final HairService _hairService;
  HairCubit(this._hairService) : super(const HairImageSelection());

  void selectImage(File image, int imageIndex) {
    final currentState = state;
    if (currentState is HairImageSelection) {
      final newState = imageIndex == 1
          ? currentState.copyWith(userImage: image)
          : currentState.copyWith(otherImage: image);
      logger.d('이미지 선택: index=$imageIndex, 새로운 상태: ${newState.props}');
      emit(newState);
    }
  }

  void removeImage(int imageIndex) {
    final currentState = state;
    if (currentState is HairImageSelection) {
      final newState = HairImageSelection(
        userImage: imageIndex == 1 ? null : currentState.userImage,
        otherImage: imageIndex == 2 ? null : currentState.otherImage,
        isLoading: currentState.isLoading,
        manipulationResult: currentState.manipulationResult,
        manipulationErrorMessage: currentState.manipulationErrorMessage,
      );
      logger.d('이미지 선택: index=$imageIndex, 새로운 상태: ${newState.props}');
      emit(newState);
    }
  }

  void clearImages() {
    emit(const HairImageSelection());
  }

  Future<void> manipulationHairStyle(
    String colorId,
    String userId,
  ) async {
    final currentState = state;
    if (currentState is! HairImageSelection) return;

    if (currentState.userImage == null || currentState.otherImage == null) {
      emit(currentState.copyWith(manipulationErrorMessage: '두 개의 이미지를 모두 선택해주세요.'));
      return;
    }

    emit(currentState.copyWith(isLoading: true, manipulationErrorMessage: null));

    try {
      final response = await _hairService.manipulationHairStyle(
          currentState.userImage!, currentState.otherImage!, userId, colorId);

      response.fold(
        (error) {
          emit(currentState.copyWith(
            isLoading: false,
            manipulationErrorMessage: error.message,
          ));
        },
        (apiResponse) {
          if (apiResponse.data != null) {
            emit(currentState.copyWith(
              isLoading: false,
              manipulationResult: apiResponse.data!,
            ));
          } else {
            emit(currentState.copyWith(
              isLoading: false,
              manipulationErrorMessage: '데이터가 없습니다.',
            ));
          }
        },
      );
    } catch (e, s) {
      emit(currentState.copyWith(
        isLoading: false,
        manipulationErrorMessage: '예상치 못한 오류가 발생했습니다: ${e.toString()}\n$s',
      ));
    }
  }

  Future<void> recommandHairStyle(String userId, String colorId) async {
    final currentState = state;
    if (currentState is! HairImageSelection) return;

    if (currentState.userImage == null) {
      emit(currentState.copyWith(recommandErrorMessage: '이미지를 선택해주세요.'));
      return;
    }

    emit(currentState.copyWith(isLoading: true, recommandErrorMessage: null));

    try {
      final response = await _hairService.recommandHairStyle(
          currentState.userImage!, userId, colorId);

      response.fold(
        (error) {
          emit(currentState.copyWith(
            isLoading: false,
            recommandErrorMessage: error.message,
          ));
        },
        (apiResponse) {
          if (apiResponse.data != null) {
            emit(currentState.copyWith(
              isLoading: false,
              recommandResult: apiResponse.data!,
            ));
          } else {
            emit(currentState.copyWith(
              isLoading: false,
              recommandErrorMessage: '데이터가 없습니다.',
            ));
          }
        },
      );
    } catch (e, s) {
      emit(currentState.copyWith(
        isLoading: false,
        recommandErrorMessage: '예상치 못한 오류가 발생했습니다: ${e.toString()}\n$s',
      ));
    }
  }
}
