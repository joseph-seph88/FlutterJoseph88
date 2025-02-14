import 'package:o2/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  // 회원가입
  Future<UserEntity?> signUp(UserEntity userEntity, String password) async {
    return await _authRepository.signUp(userEntity, password);
  }

  // 로그인
  Future<UserEntity?> signIn(String email, String password) async {
    return await _authRepository.signIn(email, password);
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
    return await _authRepository.withdraw(userId, password);
  }

  Future<UserEntity?> signInWithGoogle() async {
    return await _authRepository.signInWithGoogle();
  }

  Future<UserEntity?> signInWithFacebook() async {
    try {
      return await _authRepository.signInWithFacebook();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserEntity?> signInWithNaver() async {
    try {
      return await _authRepository.signInWithNaver();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserEntity?> signInWithKakao() async {
    try {
      return await _authRepository.signInWithKakao();
    } catch (e) {
      rethrow;
    }
  }
}
