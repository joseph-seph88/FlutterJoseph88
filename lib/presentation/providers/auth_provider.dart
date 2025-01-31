import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/datasources/auth_data_source.dart';
import 'package:o2/data/datasources/user_data_source.dart';
import 'package:o2/data/repositories/auth_repository_impl.dart';
import 'package:o2/domain/usecases/auth_use_case.dart';

import '../../data/models/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>(
  (ref) => AuthNotifier(
    AuthUseCase(
      AuthRepositoryImpl(AuthDataSource(), UserDataSource()),
    ),
  ),
);

class AuthNotifier extends StateNotifier<UserModel?> {
  final AuthUseCase authUseCase;

  AuthNotifier(this.authUseCase) : super(null);

  Future<bool> signIn(String email, String password) async {
    final user = await authUseCase.signIn(email, password);

    if (user != null) {
      state = user;
      return true;
    } else {
      return false;
    }
  }

  Future<void> signUp(String email, String password) async {
    final user = await authUseCase.signUp(email, password);

    if (user != null) state = user;
  }
}
