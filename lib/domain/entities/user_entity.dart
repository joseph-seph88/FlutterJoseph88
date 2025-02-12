import 'package:o2/data/models/user_model.dart';

class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? image;
  final List<String> favoriteProductIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.image,
    List<String>? favoriteProductIds,
    required this.createdAt,
    required this.updatedAt,
  }) : favoriteProductIds = favoriteProductIds ?? [];

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? image,
    List<String>? favoriteProductIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  UserModel toModel(String id) {
    return UserModel(
      id: id,
      email: email,
      name: name,
      image: image,
      favoriteProductIds: favoriteProductIds,
    );
  }
}
