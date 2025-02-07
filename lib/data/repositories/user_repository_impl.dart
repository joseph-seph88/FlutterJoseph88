import 'package:o2/data/datasources/user_data_source.dart';
import 'package:o2/domain/entities/user_entity.dart';
import 'package:o2/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;

  UserRepositoryImpl(this._userDataSource);

  @override
  Future<UserEntity?> getUserData(String userID) async {
    final userModel = await _userDataSource.getUser(userID);

    return userModel?.toEntity();
  }
}