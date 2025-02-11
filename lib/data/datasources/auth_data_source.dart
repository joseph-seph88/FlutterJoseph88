import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    final isGoogleLoggedIn = await GoogleSignIn().isSignedIn();
    if (isGoogleLoggedIn) {
      await GoogleSignIn().signOut();
    }

    final isFacebookLoggedIn = await FacebookAuth.instance.accessToken != null;
    if (isFacebookLoggedIn) {
      await FacebookAuth.instance.logOut();
    }

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

  // 구글 로그인
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "구글 로그인 오류";
    } catch (e) {
      throw "구글 로그인 중 오류가 발생했습니다";
    }
  }

  // 페이스북 로그인
  Future<User?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email'],
      );

      if (result.accessToken != null) {
        final credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        return userCredential.user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "페이스북 로그인 오류";
    } catch (e) {
      throw "페이스북 로그인 중 오류가 발생했습니다";
    }
  }
}
