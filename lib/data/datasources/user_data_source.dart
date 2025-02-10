import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserDataSource {
  final _firestore = FirebaseFirestore.instance;

  // 사용자 정보 저장
  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson());
  }

  // 사용자 정보 가져오기
  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> validEmail(String email) async {
    final count = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .count()
        .get();

    return count.count == 0;
  }

  Future<void> updateProfile(UserModel userModel) async {
    await _firestore
        .collection("users")
        .doc(userModel.id)
        .update(userModel.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection("users").doc(userId).delete();
  }
}
