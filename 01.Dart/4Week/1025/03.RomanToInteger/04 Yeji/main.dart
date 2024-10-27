// Roman numerals are represented by seven different symbols: I, V, X, L, C, D and M.

// Symbol       Value
// I             1
// V             5
// X             10
// L             50
// C             100
// D             500
// M             1000
// For example, 2 is written as II in Roman numeral, just two ones added together. 12 is written as XII, which is simply X + II. The number 27 is written as XXVII, which is XX + V + II.

// Roman numerals are usually written largest to smallest from left to right. However, the numeral for four is not IIII. Instead, the number four is written as IV.
// Because the one is before the five we subtract it making four. The same principle applies to the number nine, which is written as IX. There are six instances where subtraction is used:

// I can be placed before V (5) and X (10) to make 4 and 9.
// X can be placed before L (50) and C (100) to make 40 and 90.
// C can be placed before D (500) and M (1000) to make 400 and 900.
// Given a roman numeral, convert it to an integer.

// Example 1:
// Input: s = "III"
// Output: 3
// Explanation: III = 3.

// Example 2:
// Input: s = "LVIII"
// Output: 58
// Explanation: L = 50, V= 5, III = 3.

// Example 3:
// Input: s = "MCMXCIV"
// Output: 1994
// Explanation: M = 1000, CM = 900, XC = 90 and IV = 4.

// Constraints:

// 1 <= s.length <= 15
// s contains only the characters ('I', 'V', 'X', 'L', 'C', 'D', 'M').
// It is guaranteed that s is a valid roman numeral in the range [1, 3999].

class Solution {
  int romanToInt(String s) {
    Map<String, int> romanMap = {
      // 맵으로 키벨류 연결
      'I': 1,
      'V': 5,
      'X': 10,
      'L': 50,
      'C': 100,
      'D': 500,
      'M': 1000
    };

    int num = 0; // 결과값 객체

    // 문자열을 순회
    for (int i = 0; i < s.length; i++) {
      int currentValue = romanMap[s[i]]!;
      // 로드맵의 문자열s의 i번쨰의 값은 currentValue이다.

      if (i + 1 < s.length) {
        int nextValue = romanMap[s[i + 1]]!;
        // 다음 값 만들어주기

        if (currentValue < nextValue) {
          // 다음값이 현재의 값보다 크면
          num -= currentValue;
          // num에서 현재의 값 더해주기
        } else {
          num += currentValue;
          // 아님 더해주기
        }
      } else {
        num += currentValue;
        //num에다가 더하기
      }
    }

    return num;
  }
}
