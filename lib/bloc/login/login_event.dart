import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginFormEvent extends LoginEvent {
  final bool? isLoginPasswordVisible;
  final bool? isRegisterPasswordVisible;
  final bool? isConfirmPasswordVisible;
  final bool? isAgreeTerms;
  final DateTime? selectedDateTime;
  final String? gender;

  LoginFormEvent({
    this.isLoginPasswordVisible,
    this.isRegisterPasswordVisible,
    this.isConfirmPasswordVisible,
    this.isAgreeTerms,
    this.selectedDateTime,
    this.gender,
  });

  @override
  List<Object?> get props => [
        isLoginPasswordVisible,
        isRegisterPasswordVisible,
        isConfirmPasswordVisible,
        isAgreeTerms,
        selectedDateTime?.millisecondsSinceEpoch,
        gender,
      ];
}

class ResetLoginFormEvent extends LoginEvent {}
