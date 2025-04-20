import 'package:formz/formz.dart';

class PasswordValidator extends FormzInput<String, String> {
  const PasswordValidator.pure() : super.pure('');
  const PasswordValidator.dirty({String value = ''}) : super.dirty(value);

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
  );

  @override
  String? validator(String value) {
    if (value == '' || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다';
    }
    if (!_passwordRegExp.hasMatch(value)) {
      return '비밀번호는 영문, 숫자 특수문자 3개 이상으로 조합하여야합니다';
    }
    return null;
  }
}
