import 'package:o2/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? image;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "image": image,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      image: image,
    );
  }
}
