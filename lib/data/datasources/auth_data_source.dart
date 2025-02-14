import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:o2/data/datasources/auth_kakao_data_source.dart';

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

    final isNaverLoggedIn = await FlutterNaverLogin.isLoggedIn;
    if (isNaverLoggedIn) {
      await FlutterNaverLogin.logOut();
    }

    await AuthKakaoDataSource().logOut();

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

      final providerData = user.providerData;
      final providerId =
          providerData.isEmpty ? "naver.com" : providerData[0].providerId;

      switch (providerId) {
        case "password":
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );
          await user.reauthenticateWithCredential(credential);
          break;
        case "google.com":
          await GoogleSignIn().signOut();
          break;
        case "facebook.com":
          await FacebookAuth.instance.logOut();
          break;
        case "oidc.kakao_o2":
          await AuthKakaoDataSource().logOut();
          break;
        case "naver.com":
          await FlutterNaverLogin.logOut();
          break;
        default:
          throw "지원하지 않는 인증 방식입니다.";
      }

      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw '최근에 로그인한 사용자만 회원 탈퇴가 가능합니다. 다시 로그인해주세요.';
      }
      throw e.message ?? '회원 탈퇴 중 오류가 발생했습니다.';
    } catch (e) {
      throw '회원 탈퇴 중 오류가 발생했습니다.';
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
      if (e.code == "account-exists-with-different-credential") {
        throw "다른 인증 방식을 통해 가입한 이메일입니다.";
      } else {
        throw e.message ?? "페이스북 로그인 오류";
      }
    } catch (e) {
      throw "페이스북 로그인 중 오류가 발생했습니다";
    }
  }

  Future<User?> signInWithNaver() async {
    try {
      final functions = FirebaseFunctions.instance;
      final result = await FlutterNaverLogin.logIn();
      if (result.status == NaverLoginStatus.loggedIn) {
        final httpsCallableResult =
            await functions.httpsCallable("createCustomToken").call({
          "id": result.account.id,
          "email": result.account.email,
          "name": result.account.name,
        });

        final customToken = httpsCallableResult.data["customToken"];

        final userCredential = await _firebaseAuth.signInWithCustomToken(
          customToken,
        );

        return userCredential.user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "네이버 로그인 오류";
    } on FirebaseFunctionsException catch (e) {
      if (e.code == "already-exists") {
        throw "다른 인증 방식을 통해 가입한 이메일입니다.";
      } else {
        throw "네이버 로그인 중 오류가 발생했습니다";
      }
    } catch (e) {
      throw "네이버 로그인 중 오류가 발생했습니다";
    }
  }

  Future<User?> signInWithKakao() async {
    try {
      final credential = await AuthKakaoDataSource().signInWithKakao();
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "account-exists-with-different-credential") {
        throw "다른 인증 방식을 통해 가입한 이메일입니다.";
      } else {
        throw e.message ?? "카카오 로그인 오류";
      }
    } catch (e) {
      throw "카카오 로그인 중 오류가 발생했습니다";
    }
  }
}
