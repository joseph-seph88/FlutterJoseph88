import 'dart:io';
import 'package:ai_hair_official/features/models/hair_response.dart';
import 'package:equatable/equatable.dart';

abstract class HairState extends Equatable {
  const HairState();
}

class HairInitial extends HairState {
  const HairInitial();

  @override
  List<Object?> get props => [];
}

class HairLoading extends HairState {
  const HairLoading();

  @override
  List<Object?> get props => [];
}

class HairSuccess extends HairState {
  final HairResponse result;
  const HairSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class HairError extends HairState {
  final String message;
  const HairError(this.message);

  @override
  List<Object?> get props => [message];
}

class HairImageSelection extends HairState {
  final File? userImage;
  final File? otherImage;
  final bool isLoading;
  final HairResponse? manipulationResult;
  final String? manipulationErrorMessage;
  final HairResponse? recommandResult;
  final String? recommandErrorMessage;

  const HairImageSelection({
    this.userImage,
    this.otherImage,
    this.isLoading = false,
    this.manipulationResult,
    this.manipulationErrorMessage,
    this.recommandResult,
    this.recommandErrorMessage,
  });

  HairImageSelection copyWith({
    File? userImage,
    File? otherImage,
    bool? isLoading,
    HairResponse? manipulationResult,
    String? manipulationErrorMessage,
    HairResponse? recommandResult,
    String? recommandErrorMessage,
  }) {
    return HairImageSelection(
      userImage: userImage ?? this.userImage,
      otherImage: otherImage ?? this.otherImage,
      isLoading: isLoading ?? this.isLoading,
      manipulationResult: manipulationResult ?? this.manipulationResult,
      manipulationErrorMessage:
          manipulationErrorMessage ?? this.manipulationErrorMessage,
      recommandResult: recommandResult ?? this.recommandResult,
      recommandErrorMessage:
          recommandErrorMessage ?? this.recommandErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        userImage,
        otherImage,
        isLoading,
        manipulationResult,
        manipulationErrorMessage,
        recommandResult,
        recommandErrorMessage
      ];
}
