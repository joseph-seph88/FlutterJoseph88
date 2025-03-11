import 'package:equatable/equatable.dart';

abstract class AuthUIState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUIState extends AuthUIState {
  final bool isLoginPasswordVisible;
  final bool isRegisterPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isAgreeTerms;
  final DateTime? selectedDateTime;
  final String? gender;

  SignUIState({
    this.isLoginPasswordVisible = false,
    this.isRegisterPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isAgreeTerms = false,
    this.selectedDateTime,
    this.gender,
  });

  SignUIState copyWith({
    bool? isLoginPasswordVisible,
    bool? isRegisterPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isAgreeTerms,
    DateTime? selectedDateTime,
    String? gender,
  }) {
    return SignUIState(
      isLoginPasswordVisible:
          isLoginPasswordVisible ?? this.isLoginPasswordVisible,
      isRegisterPasswordVisible:
          isRegisterPasswordVisible ?? this.isRegisterPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isAgreeTerms: isAgreeTerms ?? this.isAgreeTerms,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object> get props => [
        isLoginPasswordVisible,
        isRegisterPasswordVisible,
        isConfirmPasswordVisible,
        isAgreeTerms,
        selectedDateTime?.millisecondsSinceEpoch ?? 0,
        gender ?? '',
      ];

  SignUIState reset() {
    return SignUIState();
  }
}

abstract class AuthLogicState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignLogicState extends AuthLogicState {
  final bool? isSigned;
  final bool? isLoading;
  final bool? isSignUp;
  final String? errorMessage;

  SignLogicState({
    this.isSigned = false,
    this.isLoading = false,
    this.isSignUp = false,
    this.errorMessage = "",
  });

  SignLogicState copyWith({
    bool? isSigned,
    bool? isLoading,
    bool? isSignUp,
    String? errorMessage,
  }) {
    return SignLogicState(
      isSigned: isSigned ?? this.isSigned,
      isLoading: isLoading ?? this.isLoading,
      isSignUp: isSignUp ?? this.isSignUp,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isSigned, isLoading, isSignUp, errorMessage];
}

class SignOutLogicState extends AuthLogicState {}
