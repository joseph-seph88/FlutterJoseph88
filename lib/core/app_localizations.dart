class AppLocalizations {
  final String locale;

  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'signup_title': 'Create Account',
      'name': 'Full Name',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'signup_button': 'Sign Up',
      'already_have_account': 'Already have an account?',
      'login': 'Log In',
      'name_empty': 'Please enter your name',
      'email_empty': 'Email cannot be empty',
      'email_invalid': 'Invalid email format',
      'password_empty': 'Password cannot be empty',
      'password_invalid':
          'Password must be at least 8 characters with letters and numbers',
      'passwords_dont_match': 'Passwords do not match',
      'signup_success': 'Account created successfully!',
      'signup_error': 'Failed to create account. Please try again.',
    },
    'ko': {
      'signup_title': '계정 만들기',
      'name': '이름',
      'email': '이메일',
      'password': '비밀번호',
      'confirm_password': '비밀번호 확인',
      'signup_button': '가입하기',
      'already_have_account': '이미 계정이 있으신가요?',
      'login': '로그인',
      'name_empty': '이름을 입력해주세요',
      'email_empty': '이메일을 입력해주세요',
      'email_invalid': '유효하지 않은 이메일 형식입니다',
      'password_empty': '비밀번호를 입력해주세요',
      'password_invalid': '비밀번호는 최소 8자 이상, 문자와 숫자를 포함해야 합니다',
      'passwords_dont_match': '비밀번호가 일치하지 않습니다',
      'signup_success': '계정이 성공적으로 생성되었습니다!',
      'signup_error': '계정 생성에 실패했습니다. 다시 시도해주세요.',
    }
  };

  String get(String key) {
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }

  static AppLocalizations of(String locale) {
    return AppLocalizations(locale);
  }
}
