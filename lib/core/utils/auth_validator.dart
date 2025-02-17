import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/auth_provider.dart';

class ValidatorResult {
  final bool isValid;
  final String? errorMessage;

  ValidatorResult({required this.isValid, required this.errorMessage});
}

class AuthValidator {
  static final emailRegex = RegExp(
      r'^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$');
  static final socialEmailRegex = RegExp(
      r'^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@(google\.com|naver\.com|kakao\.com)$');
  static final passwordRegex = RegExp(
      r'^(?!((?:[A-Za-z]+)|(?:[~!@#$%^&*()_+=]+)|(?:[0-9]+))$)[A-Za-z\d~!@#$%^&*()_+=]{6,}$');

  static Future<ValidatorResult> validateEmail(
      String email, WidgetRef ref) async {
    if (!emailRegex.hasMatch(email)) {
      return ValidatorResult(
          isValid: false, errorMessage: "이메일 형식이 올바르지 않습니다.");
    }

    if (socialEmailRegex.hasMatch(email)) {
      return ValidatorResult(isValid: false, errorMessage: "소셜 로그인을 사용해주세요.");
    }

    if (!await ref.read(authProvider.notifier).validEmail(email)) {
      return ValidatorResult(isValid: false, errorMessage: "이미 사용중인 이메일입니다.");
    }

    return ValidatorResult(isValid: true, errorMessage: null);
  }

  static ValidatorResult validatePassword(String password) {
    if (!passwordRegex.hasMatch(password)) {
      return ValidatorResult(isValid: false, errorMessage: "사용할 수 없는 비밀번호입니다.");
    }

    return ValidatorResult(isValid: true, errorMessage: null);
  }

  static ValidatorResult validatePasswordConfirm(
      String password, String passwordConfirm) {
    if (password != passwordConfirm) {
      return ValidatorResult(isValid: false, errorMessage: "비밀번호가 일치하지 않습니다.");
    }

    return ValidatorResult(isValid: true, errorMessage: null);
  }

  static ValidatorResult validateName(String name) {
    if (name.trim().isEmpty) {
      return ValidatorResult(isValid: false, errorMessage: "이름을 입력해주세요.");
    }
    return ValidatorResult(isValid: true, errorMessage: null);
  }
}
