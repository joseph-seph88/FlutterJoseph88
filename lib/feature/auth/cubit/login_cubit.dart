import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:project_login/feature/auth/cubit/login_state.dart';
import 'package:project_login/feature/auth/domain/form_validator/email_validator.dart';
import 'package:project_login/feature/auth/domain/form_validator/password_validator.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void loginSubmitted(
      {required String emailValue, required String passwordValue}) {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final email = EmailValidator.dirty(value: emailValue);
    final password = PasswordValidator.dirty(value: passwordValue);
    final isFormValid = Formz.validate([email, password]);

    if (isFormValid) {
      emit(state.copyWith(
        email: email,
        password: password,
        status: FormzSubmissionStatus.success,
      ));
    } else {
      emit(state.copyWith(
        email: email,
        password: password,
        status: FormzSubmissionStatus.failure,
      ));
    }
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    ));
  }

//   Future<void> logInWithCredentials() async {
//     if (!state.status.isValidated) return;
//     emit(state.copyWith(status: FormzStatus.submissionInProgress));
//     try {
//       // 여기에 실제 로그인 로직을 추가할 수 있습니다.
//       // 예: await authRepository.logIn(email: state.email.value, password: state.password.value);

//       // 테스트를 위해 잠시 딜레이
//       await Future.delayed(const Duration(seconds: 2));

//       emit(state.copyWith(status: FormzStatus.submissionSuccess));
//     } catch (e) {
//       emit(state.copyWith(
//         errorMessage: e.toString(),
//         status: FormzStatus.submissionFailure,
//       ));
//     }
//   }
}
