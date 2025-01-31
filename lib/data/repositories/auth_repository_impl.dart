import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';
import '../datasources/user_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final UserDataSource _userDataSource;

  AuthRepositoryImpl(this._authDataSource, this._userDataSource);

  @override
  Future<UserModel?> signUp(String email, String password) async {
    final user = await _authDataSource.signUp(email, password);
    if (user != null) {
      final userModel = UserModel.fromFirebaseUser(user);
      await _userDataSource.saveUser(userModel);
      return userModel;
    }
    return null;
  }

  @override
  Future<UserModel?> signIn(String email, String password) async {
    final user = await _authDataSource.signIn(email, password);
    if (user != null) {
      final userModel = UserModel.fromFirebaseUser(user);
      return userModel;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = _authDataSource.getCurrentUser();
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }
}
