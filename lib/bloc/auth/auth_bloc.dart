import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_select_chat/bloc/auth/auth_event.dart';
import 'package:personal_select_chat/bloc/auth/auth_state.dart';
import '../../core/app/router/router_bloc.dart';
import '../../core/app/router/router_event.dart';
import '../../domain/use_cases/auth_use_case.dart';

class AuthUIBloc extends Bloc<AuthUIEvent, AuthUIState> {
  AuthUIBloc() : super(SignUIState()) {
    on<SignUIEvent>((event, emit) {
      final signFormatState = state as SignUIState;
      emit(signFormatState.copyWith(
        isLoginPasswordVisible: event.isLoginPasswordVisible ??
            signFormatState.isLoginPasswordVisible,
        isRegisterPasswordVisible: event.isRegisterPasswordVisible ??
            signFormatState.isRegisterPasswordVisible,
        isConfirmPasswordVisible: event.isConfirmPasswordVisible ??
            signFormatState.isConfirmPasswordVisible,
        isAgreeTerms: event.isAgreeTerms ?? signFormatState.isAgreeTerms,
        selectedDateTime:
            event.selectedDateTime ?? signFormatState.selectedDateTime,
        gender: event.gender ?? signFormatState.gender,
      ));
    });

    on<ResetSignUIEvent>((event, emit) async {
      emit(SignUIState().reset());
    });
  }
}

class AuthLogicBloc extends Bloc<AuthLogicEvent, AuthLogicState>
    with ChangeNotifier {
  final AuthUseCase _authUseCase;
  final RouterBloc _routerBloc;

  AuthLogicBloc(this._authUseCase, this._routerBloc) : super(SignLogicState()) {
    on<SignInLogicEvent>((event, emit) async {
      if (state is SignLogicState) {
        final signInState = state as SignLogicState;
        emit(signInState.copyWith(isLoading: true, errorMessage: ""));

        try {
          final isSuccess =
              await _authUseCase.signIn(event.email, event.password);
          if (isSuccess) {
            emit(signInState.copyWith(isSigned: true, isLoading: false));
            _routerBloc.add(RouterLoginEvent());
          }
        } catch (e) {
          emit(signInState.copyWith(
              errorMessage: e.toString(), isLoading: false));
        }
      } else {
        throw Exception('[AuthBloc] SignInLogicEvent Error: $state');
      }
    });

    on<SignUpLogicEvent>((event, emit) async {
      if (state is SignLogicState) {
        final signUpState = state as SignLogicState;
        emit(signUpState.copyWith(isLoading: true, errorMessage: ""));
        try {
          final isSuccess =
              await _authUseCase.signUp(event.email, event.password);
          if (isSuccess) {
            emit(signUpState.copyWith(isSignUp: true, isLoading: false));
            _routerBloc.add(RouterInitialEvent());
          }
        } catch (e) {
          emit(signUpState.copyWith(
              errorMessage: e.toString(), isLoading: false));
        }
      } else {
        throw Exception('[AuthBloc] SignUpLogicEvent Error: $state');
      }
    });

    on<SignInUpWithGoogleLogicEvent>((event, emit) async {
      final signInUpWithGoogleState = state as SignLogicState;
      emit(signInUpWithGoogleState.copyWith(isLoading: true, errorMessage: ""));

      try {
        final isSuccess = await _authUseCase.signInUpWithGoogle();
        if (isSuccess) {
          emit(signInUpWithGoogleState.copyWith(
              isSigned: true, isLoading: false));
          _routerBloc.add(RouterLoginEvent());
        }
      } catch (e) {
        emit(signInUpWithGoogleState.copyWith(
            errorMessage: e.toString(), isLoading: false));
      }
    });

    on<SignOutLogicEvent>((event, emit) async {
      try {
        await _authUseCase.signOut();
        _routerBloc.add(RouterLogoutEvent());

      } catch (e) {
        throw Exception('[AuthBloc] SignOutLogicEvent Error: ${e.toString()}');
      }
    });
  }
}
