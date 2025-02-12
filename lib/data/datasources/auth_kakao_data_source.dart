import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthKakaoDataSource {
  Future<OAuthCredential> signInWithKakao() async {
    try {
      final provider = OAuthProvider("oidc.kakao_o2");
      final token = await UserApi.instance.loginWithKakaoAccount();

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
        await UserApi.instance.logout();
      }
    } catch (error) {
      rethrow;
    }
  }
}
