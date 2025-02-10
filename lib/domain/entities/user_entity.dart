import 'package:o2/data/models/user_model.dart';

class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? image;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.image,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? image,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  UserModel toModel(String id) {
    return UserModel(
      id: id,
      email: email,
      name: name,
      image: image,
    );
  }
}
