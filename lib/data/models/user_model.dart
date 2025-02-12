import 'package:o2/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? image;
  final List<String> favoriteProductIds;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.image,
    List<String>? favoriteProductIds,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  })  : favoriteProductIds = favoriteProductIds ?? [],
        createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      image: json["image"],
      favoriteProductIds: List<String>.from(json["favoriteProductIds"] ?? []),
      createdAt: json["createdAt"] ?? Timestamp.now(),
      updatedAt: json["updatedAt"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "image": image,
      "favoriteProductIds": favoriteProductIds,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      image: image,
      favoriteProductIds: favoriteProductIds,
      createdAt: createdAt.toDate(),
      updatedAt: updatedAt.toDate(),
    );
  }
}
