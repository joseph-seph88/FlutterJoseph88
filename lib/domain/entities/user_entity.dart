import 'package:o2/data/models/user_model.dart';

class UserEntity {
  final String id;
  final String email;
  final String name;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
  });

  UserModel toModel(String id) {
    return UserModel(
      id: id,
      email: email,
      name: name,
    );
  }
}
