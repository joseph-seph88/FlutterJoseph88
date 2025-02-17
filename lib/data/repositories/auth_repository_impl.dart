import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:o2/core/constants/auth_provider_type.dart';
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
    try {
      await _authDataSource.withdraw(password);
      await _userDataSource.deleteUser(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signInWithProvider(
    AuthProviderType authProviderType, {
    String? email,
    String? password,
  }) async {
    try {
      final user = await _authDataSource.signInWithProvider(
        authProviderType,
        email: email,
        password: password,
      );

      if (user == null) return null;

      final existingUser = await _userDataSource.getUser(user.uid);
      if (existingUser != null) {
        return existingUser.toEntity();
      }

      final newUser = UserEntity(
        id: user.uid,
        email: email ?? await setEmail(authProviderType),
        name: user.displayName ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userDataSource.saveUser(newUser.toModel(user.uid));
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> setEmail(AuthProviderType authProviderType) async {
    String email = "";
    switch (authProviderType) {
      case AuthProviderType.facebook:
        final userData = await FacebookAuth.instance.getUserData();
        return userData['email'] ?? '';
      case AuthProviderType.kakao:
        final userData = await UserApi.instance.me();
        return userData.kakaoAccount?.email ?? '';
      default:
        return email;
    }
  }
}
