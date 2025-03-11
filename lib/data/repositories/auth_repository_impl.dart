import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_select_chat/data/data_sources/auth_local_data_source.dart';
import 'package:personal_select_chat/data/data_sources/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userInfo = await _remoteDataSource.getCurrentUser();
      if (userInfo == null) {
        throw Exception("[FAuth-REPO] getCurrentUser null");
      }
      return userInfo;
    } catch (e) {
      throw Exception("[FAuth-REPO] getCurrentUser error: ${e.toString()}");
    }
  }

  @override
  Future<bool> signIn(String email, String password) async {
    try {
      final userInfo = await _remoteDataSource.signIn(email, password);
      if(userInfo !=null){
        return true;
      }
      return false;
    } catch (e) {
      throw Exception("[FAuth-REPO] signIn error: ${e.toString()}");
    }
  }

  @override
  Future<bool> signInUpWithGoogle() async {
    try {
      final userInfo = await _remoteDataSource.signInUpWithGoogle();
      if(userInfo !=null){
        return true;
      }
      return false;
    } catch (e) {
      throw Exception("[FAuth-REPO] signInUpWithGoogle error: ${e.toString()}");
    }
  }

  @override
  Future<bool> signUp(String email, String password) async {
    try {
      final userInfo = await _remoteDataSource.signUp(email, password);
      if(userInfo != null){
        return true;
      }
      return false;
    } catch (e) {
      throw Exception("[FAuth-REPO] signUp error: ${e.toString()}");
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      throw Exception("[FAuth-REPO] signOut error: ${e.toString()}");
    }
  }
}
