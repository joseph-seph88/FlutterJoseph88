import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final _login = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<User?> loginUser(String email, String password) async {
    try {
      final userCredential = await _login.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user?.uid;
      final userDoc = await _db.collection("users").doc(userId).get();

      if (userDoc.exists) {
        return userCredential.user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error logging in user: $e');
      return null;
    }
  }

  Future<String?> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
      await _login.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {

        await _db.collection("users").doc(userId).set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return '회원가입 성공';
      }
      return '회원가입 실패';
    } on FirebaseAuthException catch (e) {
      return '오류 발생: ${e.message}';
    }
  }
}

