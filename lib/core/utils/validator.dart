class Validator {
  static String? isEmptyValidator(String? value, String validationMessage) {
    if (value == null || value.isEmpty) {
      return validationMessage;
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      final emailFormat =
          RegExp(r'[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value);

      if (!emailFormat) {
        return '올바른 이메일 형식이 아닙니다';
      }
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      final hasCase = RegExp(r'[a-zA-Z]').hasMatch(value);
      final hasDigits = RegExp(r'[0-9]').hasMatch(value);
      final hasSpecialChar = RegExp(r'[\W_]').hasMatch(value);

      if (value.length < 8) {
        return '비밀번호는 최소 8자 이상이어야 합니다';
      } else if (!hasCase || !hasDigits || !hasSpecialChar) {
        return '비밀번호는 영문, 숫자, 특수문자가 각각 1개 이상 포함되어야 합니다';
      }
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value != null && value.isNotEmpty) {
      if (value != password) {
        return '비밀번호가 서로 다릅니다';
      }
    }
    return null;
  }
}
