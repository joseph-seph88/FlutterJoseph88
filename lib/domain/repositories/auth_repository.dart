import 'package:o2/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signUp(UserEntity userEntity, String password);
  Future<UserEntity?> signIn(String email, String password);
  Future<void> signOut();
  Future<bool> validEmail(String email);
  Future<void> updateProfile(UserEntity userEntity);
  Future<UserEntity?> getCurrentUser();
  Future<void> withdraw(String userId, String password);
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithFacebook();
}
