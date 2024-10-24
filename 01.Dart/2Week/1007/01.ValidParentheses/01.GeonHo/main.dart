class Solution {
  bool isValid(String s) {
    List<String> stack = [];
    Map<String, String> matchingMap = {"(": ")", "{": "}", "[": "]"};

    for (String char in s.split('')) {
      if (matchingMap.containsKey(char)) {
        stack.add(char);
      } else {
        if (!stack.isEmpty && matchingMap[stack.last] == char) {
          stack.removeLast();
        } else {
          return false;
        }
      }
    }

    return stack.isEmpty;
  }
}

void main() {
  Solution solution = Solution();
  // bool result11 = solution.isValid("}");
  // bool result1 = solution.isValid("{");
  // bool result = solution.isValid("()");
  // bool result2 = solution.isValid("()[]{}");
  // bool result3 = solution.isValid("(]");
  bool result4 = solution.isValid("([])");
  print(result4);
}
