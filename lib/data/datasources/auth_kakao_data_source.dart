import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthKakaoDataSource {
  final _kakaoAuth = UserApi.instance;

  Future<OAuthCredential> signInWithKakao() async {
    try {
      final provider = OAuthProvider("oidc.kakao_o2");
      final token = await _kakaoAuth.loginWithKakaoAccount();

      final credential = provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );
      return credential;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      if (await AuthApi.instance.hasToken()) {
        await _kakaoAuth.logout();
      }
    } catch (error) {
      rethrow;
    }
  }
}
