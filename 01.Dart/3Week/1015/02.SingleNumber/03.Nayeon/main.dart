void main() {
  List<int> inputNum1 = [2, 2, 1];
  //output : 1

  List<int> inputNum2 = [4, 1, 2, 1, 2];
  //output : 4

  List<int> inputNum3 = [1];
  //output : 1

  Solution solution = Solution();

  print(solution.singleNumber(inputNum1)); //1
  print(solution.singleNumber(inputNum2)); //4
  print(solution.singleNumber(inputNum3)); //1
}

class Solution {
  int singleNumber(List<int> nums) {
    int result = 0;

    // 모든 숫자를 XOR 연산
    for (int num in nums) {
      result ^= num;
    }

    return result;
  }
}
