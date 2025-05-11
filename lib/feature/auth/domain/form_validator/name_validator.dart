import 'package:formz/formz.dart';

class NameValidator extends FormzInput<String, String> {
  const NameValidator.pure() : super.pure('');
  const NameValidator.dirty({String value = ''}) : super.dirty(value);

  static final RegExp _nameRegExp = RegExp(r'^[가-힣a-zA-Z]+$');

  @override
  String? validator(String value) {
    if (value == '' || value.isEmpty) {
      return '이름을 입력해주세요';
    }
    if (!_nameRegExp.hasMatch(value)) {
      return '유효한 이름을 입력해주세요';
    }
    if (value.length > 13) {
      return '이름은 12자 이하로 입력해주세요';
    }
    return null;
  }
}
