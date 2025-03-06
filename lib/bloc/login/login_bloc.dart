import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_select_chat/bloc/login/login_event.dart';
import 'package:personal_select_chat/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginFormState()) {
    on<LoginFormEvent>((event, emit) {
      final loginState = state as LoginFormState;
      emit(loginState.copyWith(
        isLoginPasswordVisible:
            event.isLoginPasswordVisible ?? loginState.isLoginPasswordVisible,
        isRegisterPasswordVisible: event.isRegisterPasswordVisible ??
            loginState.isRegisterPasswordVisible,
        isConfirmPasswordVisible: event.isConfirmPasswordVisible ??
            loginState.isConfirmPasswordVisible,
        isAgreeTerms: event.isAgreeTerms ?? loginState.isAgreeTerms,
        selectedDateTime: event.selectedDateTime ?? loginState.selectedDateTime,
        gender: event.gender ?? loginState.gender,
      ));
    });

    on<ResetLoginFormEvent>((event, emit){
      emit(LoginFormState());
    });
  }
}
