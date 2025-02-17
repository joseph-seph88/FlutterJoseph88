import 'package:o2/core/constants/auth_provider_type.dart';
import 'package:o2/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  // 회원가입
  Future<UserEntity?> signUp(UserEntity userEntity, String password) async {
    return await _authRepository.signUp(userEntity, password);
  }

  // 로그아웃
  Future<void> signOut() async {
    return await _authRepository.signOut();
  }

  Future<bool> validEmail(String email) async {
    return await _authRepository.validEmail(email);
  }

  Future<void> updateProfile(UserEntity userEntity) async {
    return await _authRepository.updateProfile(userEntity);
  }

  Future<UserEntity?> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }

  Future<void> withdraw(String userId, String password) async {
    try {
      return await _authRepository.withdraw(userId, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserEntity?> signInWithProvider(
    AuthProviderType authProviderType, {
    String? email,
    String? password,
  }) async {
    try {
      return await _authRepository.signInWithProvider(
        authProviderType,
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
}
