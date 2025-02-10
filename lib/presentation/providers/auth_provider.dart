import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/datasources/auth_data_source.dart';
import 'package:o2/data/datasources/user_data_source.dart';
import 'package:o2/data/repositories/auth_repository_impl.dart';
import 'package:o2/domain/entities/user_entity.dart';
import 'package:o2/domain/usecases/auth_use_case.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserEntity?>(
  (ref) => AuthNotifier(
    AuthUseCase(
      AuthRepositoryImpl(AuthDataSource(), UserDataSource()),
    ),
  ),
);

class AuthNotifier extends StateNotifier<UserEntity?> {
  final AuthUseCase authUseCase;

  AuthNotifier(this.authUseCase) : super(null) {
    getCurrentUser();
  }

  Future<bool> signIn(String email, String password) async {
    final user = await authUseCase.signIn(email, password);

    if (user != null) {
      state = user;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp(UserEntity userEntity, String password) async {
    final user = await authUseCase.signUp(userEntity, password);

    if (user != null) {
      state = user;
      return true;
    } else {
      return false;
    }
  }

  Future<void> signOut() async {
    await authUseCase.signOut();
    state = null;
  }

  Future<bool> validEmail(String email) async {
    return authUseCase.validEmail(email);
  }

  Future<void> updateProfile(UserEntity userEntity) async {
    await authUseCase.updateProfile(userEntity);
    state = userEntity;
  }

  Future<void> getCurrentUser() async {
    final user = await authUseCase.getCurrentUser();
    if (user != null) {
      state = user;
    }
  }

  Future<void> withdraw(String userId, String password) async {
    await authUseCase.withdraw(userId, password);
    state = null;
  }
}
