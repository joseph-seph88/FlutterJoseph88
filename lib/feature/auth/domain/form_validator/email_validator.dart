import 'package:formz/formz.dart';

class EmailValidator extends FormzInput<String, String> {
  const EmailValidator.pure() : super.pure('');
  const EmailValidator.dirty({String value = ''}) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9]{2,}@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$',
  );

  @override
  String? validator(String value) {
    if (value == '' || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return '유효한 이메일을 입력해주세요';
    }
    if (value.length > 128) {
      return '이메일은 128자 이하로 입력해주세요';
    }
    return null;
  }
}
