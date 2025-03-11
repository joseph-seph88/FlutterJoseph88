import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String userId;
  final String email;
  final String name;
  final String? photoUrl;
  final Timestamp? createdAt;

  const UserEntity({
    required this.userId,
    required this.email,
    required this.name,
    this.photoUrl,
    this.createdAt,
  });
}