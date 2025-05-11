import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:project_login/feature/auth/domain/form_validator/email_validator.dart';
import 'package:project_login/feature/auth/domain/form_validator/name_validator.dart';
import 'package:project_login/feature/auth/domain/form_validator/password_confirm_validator.dart';
import 'package:project_login/feature/auth/domain/form_validator/password_validator.dart';

class SignupState extends Equatable {
  final EmailValidator email;
  final PasswordValidator password;
  final PasswordConfirmValidator confirmPassword;
  final NameValidator name;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const SignupState({
    this.email = const EmailValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.confirmPassword = const PasswordConfirmValidator.pure(),
    this.name = const NameValidator.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  SignupState copyWith({
    EmailValidator? email,
    PasswordValidator? password,
    PasswordConfirmValidator? confirmPassword,
    NameValidator? name,
    FormzSubmissionStatus? status,
    String? errorMessage,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        name,
        status,
        errorMessage,
        isPasswordVisible,
        isConfirmPasswordVisible,
      ];
}
