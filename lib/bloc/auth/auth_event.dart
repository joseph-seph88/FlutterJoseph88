import 'package:equatable/equatable.dart';

abstract class AuthUIEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUIEvent extends AuthUIEvent {
  final bool? isLoginPasswordVisible;
  final bool? isRegisterPasswordVisible;
  final bool? isConfirmPasswordVisible;
  final bool? isAgreeTerms;
  final DateTime? selectedDateTime;
  final String? gender;

  SignUIEvent({
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

class ResetSignUIEvent extends AuthUIEvent {}

abstract class AuthLogicEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInLogicEvent extends AuthLogicEvent {
  final String email;
  final String password;

  SignInLogicEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUpLogicEvent extends AuthLogicEvent {
  final String email;
  final String password;

  SignUpLogicEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignInUpWithGoogleLogicEvent extends AuthLogicEvent {}

class SignOutLogicEvent extends AuthLogicEvent {}

