import 'package:o2/domain/entities/user_entity.dart';
import 'package:o2/domain/repositories/user_repository.dart';

class GetUserDataUseCase {
  final UserRepository _repository;

  GetUserDataUseCase(this._repository);

  Future<UserEntity?> call(String userID) {
    return _repository.getUserData(userID);
  }
}