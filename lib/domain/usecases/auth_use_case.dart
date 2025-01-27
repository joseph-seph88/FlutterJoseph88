import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  // 회원가입
  Future<UserModel?> signUp(String email, String password) async {
    return await _authRepository.signUp(email, password);
  }

  // 로그인
  Future<UserModel?> signIn(String email, String password) async {
    return await _authRepository.signIn(email, password);
  }

  // 로그아웃
  Future<void> signOut() async {
    return await _authRepository.signOut();
  }

  // 현재 로그인한 사용자 정보 가져오기
  UserModel? getCurrentUser() {
    return _authRepository.getCurrentUser();
  }
}
