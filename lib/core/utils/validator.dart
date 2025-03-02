class Validator{
  String? isEmptyValidator(String? value){
    if (value == null || value.isEmpty) {
      return 'URL을 입력해 주세요';
    }
    return null;
  }

  String? titleValidator(String? value){
    if (value == null || value.isEmpty) {
      return '제목을 입력해 주세요';
    }
    if (value.length > 30) {
      return '제목은 30자 이내로 입력해 주세요';
    }
    return null;
  }
}