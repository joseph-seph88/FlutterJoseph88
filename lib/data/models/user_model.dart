import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_select_chat/domain/entities/user_entity.dart';

class UserModel {
  final String userId;
  final String email;
  final String name;
  final String? photoUrl;
  final Timestamp createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    this.photoUrl,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      name: name,
      photoUrl: photoUrl,
      createdAt: createdAt,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> mapData) {
    return UserModel(
      userId: mapData['userId'],
      email: mapData['email'],
      name: mapData['name'],
      photoUrl: mapData['photoUrl'],
      createdAt: mapData['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "email": email,
      "name": name,
      "photoUrl": photoUrl,
      "createdAt": createdAt,
    };
  }
}
