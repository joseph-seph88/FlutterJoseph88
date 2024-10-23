// 3. Longest Substring Without Repeating Characters : 적당히 어려운
// https://leetcode.com/problems/longest-substring-without-repeating-characters/description/

// Medium
// Topics
// Companies
// Hint
// Given a string s, find the length of the longest
// substring
//  without repeating characters.

// Example 1:

// Input: s = "abcabcbb"
// Output: 3
// Explanation: The answer is "abc", with the length of 3.
// Example 2:

// Input: s = "bbbbb"
// Output: 1
// Explanation: The answer is "b", with the length of 1.
// Example 3:

// Input: s = "pwwkew"
// Output: 3
// Explanation: The answer is "wke", with the length of 3.
// Notice that the answer must be a substring, "pwke" is a subsequence and not a substring.

// Constraints:

// 0 <= s.length <= 5 * 104
// s consists of English letters, digits, symbols and spaces.

// Dart로 풀기

void main() {
  String s = "abcabcbb";

  Solution solution = Solution();
  print(solution.lengthOfLongestSubstring(s));
}

class Solution {
  int lengthOfLongestSubstring(String s) {
    // 각 문자의 마지막 위치를 기록할 Map을 만듭니다.
    Map<String, int> lastSeen = {};
    int maxLength = 0; // 가장 긴 부분 문자열의 길이를 저장할 변수
    int start = 0; // 현재 부분 문자열의 시작 위치를 기록할 변수

    for (int i = 0; i < s.length; i++) {
      String currentChar = s[i];

      // 만약 현재 문자가 이미 lastSeen에 존재하고, 그 위치가 start보다 크거나 같으면,
      // 중복된 문자가 있기 때문에 start를 갱신합니다.
      if (lastSeen.containsKey(currentChar) &&
          lastSeen[currentChar]! >= start) {
        start = lastSeen[currentChar]! + 1;
      }

      // 현재 문자의 위치를 lastSeen에 업데이트합니다.
      lastSeen[currentChar] = i;

      // 현재 부분 문자열의 길이를 계산하고, maxLength를 업데이트합니다.
      maxLength = maxLength < (i - start + 1) ? (i - start + 1) : maxLength;
    }

    // 가장 긴 부분 문자열의 길이를 반환합니다.
    return maxLength;
  }
}
