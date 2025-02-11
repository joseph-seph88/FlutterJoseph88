class SearchUtils {
  // 검색 키워드 생성 메서드
  static List<String> generateSearchKeywords(String title, String description) {
    final Set<String> keywords = {};

    // 제목과 설명을 소문자로 변환
    final lowercaseTitle = title.toLowerCase();
    final lowercaseDescription = description.toLowerCase();

    // 1. 제목에서 키워드 추출
    final titleWords = lowercaseTitle.split(RegExp(r'[\s,]+'));
    for (final word in titleWords) {
      if (word.length >= 2) {
        // 2글자 이상만 포함
        keywords.add(word);

        // 초성 추출 (한글인 경우)
        if (RegExp(r'[가-힣]+').hasMatch(word)) {
          final chosung = _extractChosung(word);
          if (chosung.length >= 2) {
            keywords.add(chosung);
          }
        }
      }
    }

    // 2. 설명에서 주요 단어 추출
    final descriptionWords = lowercaseDescription.split(RegExp(r'[\s,]+'));
    for (final word in descriptionWords) {
      if (word.length >= 2 && !keywords.contains(word)) {
        // 중복 제외, 2글자 이상
        keywords.add(word);
      }
    }

    // 3. 카테고리 관련 키워드 추가
    final commonKeywords = [
      '중고',
      '새제품',
      '할인',
      '급처',
    ];
    keywords.addAll(commonKeywords.where((keyword) =>
        lowercaseTitle.contains(keyword) ||
        lowercaseDescription.contains(keyword)));

    return keywords.toList();
  }

  // 초성 추출 메서드
  static String _extractChosung(String text) {
    const chosungList = [
      'ㄱ',
      'ㄲ',
      'ㄴ',
      'ㄷ',
      'ㄸ',
      'ㄹ',
      'ㅁ',
      'ㅂ',
      'ㅃ',
      'ㅅ',
      'ㅆ',
      'ㅇ',
      'ㅈ',
      'ㅉ',
      'ㅊ',
      'ㅋ',
      'ㅌ',
      'ㅍ',
      'ㅎ'
    ];
    String result = '';

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (RegExp(r'[가-힣]').hasMatch(char)) {
        final unicode = char.codeUnitAt(0) - '가'.codeUnitAt(0);
        final chosungIndex = unicode ~/ (21 * 28);
        if (chosungIndex >= 0 && chosungIndex < chosungList.length) {
          result += chosungList[chosungIndex];
        }
      }
    }

    return result;
  }
}
