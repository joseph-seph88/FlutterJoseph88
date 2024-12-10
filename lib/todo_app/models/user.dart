class UserModel {
  final int? id;
  final String email;
  final String nickname;

  UserModel({
    this.id,
    required this.email,
    required this.nickname,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      nickname: map['nickname'],
    );
  }
}
