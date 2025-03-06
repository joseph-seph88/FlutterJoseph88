import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginFormState extends LoginState {
  final bool isLoginPasswordVisible;
  final bool isRegisterPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isAgreeTerms;
  final DateTime? selectedDateTime;
  final String? gender;

  LoginFormState({
    this.isLoginPasswordVisible = false,
    this.isRegisterPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isAgreeTerms = false,
    this.selectedDateTime,
    this.gender,
  });

  LoginFormState copyWith({
    bool? isLoginPasswordVisible,
    bool? isRegisterPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isAgreeTerms,
    DateTime? selectedDateTime,
    String? gender,
  }) {
    return LoginFormState(
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
}
