import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:project_login/feature/auth/domain/form_validator/email_validator.dart';
import 'package:project_login/feature/auth/domain/form_validator/password_validator.dart';

class LoginState extends Equatable {
  final EmailValidator email;
  final PasswordValidator password;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final bool isPasswordVisible;

  const LoginState({
    this.email = const EmailValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.isPasswordVisible = false,
  });

  LoginState copyWith({
    EmailValidator? email,
    PasswordValidator? password,
    FormzSubmissionStatus? status,
    String? errorMessage,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        errorMessage,
        isPasswordVisible,
      ];
}
