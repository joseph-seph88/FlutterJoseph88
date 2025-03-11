import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase{
  final AuthRepository _repository;

  AuthUseCase(this._repository);

  Future<User?> getCurrentUser() async {
    try {
      final userInfo = await _repository.getCurrentUser();
      if (userInfo == null) {
        throw Exception("[FAuth-USE] getCurrentUser null");
      }
      return userInfo;
    } catch (e) {
      throw Exception("[FAuth-USE] getCurrentUser error: ${e.toString()}");
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final isSuccess = await _repository.signIn(email, password);
      return isSuccess;
    } catch (e) {
      throw Exception("[FAuth-USE] signIn error: ${e.toString()}");
    }
  }

  Future<bool> signInUpWithGoogle() async {
    try {
      final isSuccess = await _repository.signInUpWithGoogle();
      return isSuccess;
    } catch (e) {
      throw Exception("[FAuth-USE] signInUpWithGoogle error: ${e.toString()}");
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final isSuccess = await _repository.signUp(email, password);
      return isSuccess;
    } catch (e) {
      throw Exception("[FAuth-USE] signUp error: ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
    } catch (e) {
      throw Exception("[FAuth-USE] signOut error: ${e.toString()}");
    }
  }
}