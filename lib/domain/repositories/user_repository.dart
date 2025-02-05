import 'package:o2/domain/entities/user_entity.dart';

abstract interface class UserRepository {
  Future<UserEntity?> getUserData(String userID);
}