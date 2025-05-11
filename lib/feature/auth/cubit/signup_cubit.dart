import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_login/feature/auth/cubit/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState());

  void togglePasswordVisibility() {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    ));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    ));
  }
}
