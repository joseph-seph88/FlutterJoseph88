import 'package:o2/domain/entities/user_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';
import '../datasources/user_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final UserDataSource _userDataSource;

  AuthRepositoryImpl(this._authDataSource, this._userDataSource);

  @override
  Future<UserEntity?> signUp(UserEntity userEntity, String password) async {
    final user = await _authDataSource.signUp(userEntity.email, password);

    if (user != null) {
      await _userDataSource.saveUser(userEntity.toModel(user.uid));
      final userData = await _userDataSource.getUser(user.uid);

      if (userData != null) {
        return userData.toEntity();
      }
    }

    return null;
  }

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final user = await _authDataSource.signIn(email, password);
    if (user != null) {
      final userData = await _userDataSource.getUser(user.uid);
      if (userData != null) {
        return userData.toEntity();
      }
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  Future<bool> validEmail(String email) async {
    return await _userDataSource.validEmail(email);
  }

  @override
  Future<void> updateProfile(UserEntity userEntity) async {
    final userModel = userEntity.toModel(userEntity.id);
    await _userDataSource.updateProfile(userModel);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final currentUser = _authDataSource.getCurrentUser();
    if (currentUser != null) {
      final userData = await _userDataSource.getUser(currentUser.uid);
      if (userData != null) {
        return userData.toEntity();
      }
    }
    return null;
  }

  @override
  Future<void> withdraw(String userId, String password) async {
    await _userDataSource.deleteUser(userId);
    await _authDataSource.withdraw(password);
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final user = await _authDataSource.signInWithGoogle();
    if (user != null) {
      final existingUser = await _userDataSource.getUser(user.uid);
      if (existingUser != null) {
        return existingUser.toEntity();
      }

      final newUser = UserEntity(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
      );
      await _userDataSource.saveUser(newUser.toModel(user.uid));
      return newUser;
    }
    return null;
  }
}
