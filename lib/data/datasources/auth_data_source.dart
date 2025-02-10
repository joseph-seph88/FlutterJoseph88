import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  final _firebaseAuth = FirebaseAuth.instance;

  // 회원가입
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "회원가입 오류";
    }
  }

  // 로그인
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "로그인 오류";
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // 현재 로그인한 사용자 가져오기
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // 회원 탈퇴
  Future<void> withdraw(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await user.delete();
    } catch (e) {
      rethrow;
    }
  }
}
