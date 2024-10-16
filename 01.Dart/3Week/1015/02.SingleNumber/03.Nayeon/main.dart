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


// XOR(배타적 논리합) 연산자 ^:
// XOR는 배타적 논리합을 의미하며, 두 비트가 서로 다를 때 1을 반환하고, 같으면 0을 반환합니다.

// 1 ^ 1 = 0
// 0 ^ 0 = 0
// 1 ^ 0 = 1
// 0 ^ 1 = 1
// 즉, 두 비트가 서로 다르면 1, 같으면 0이 됩니다.