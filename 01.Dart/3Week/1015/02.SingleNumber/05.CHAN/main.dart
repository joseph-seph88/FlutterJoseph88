void main() {
  List<int> inputNum1 = [2, 2, 1];
  //output : 1

  List<int> inputNum2 = [4, 1, 2, 1, 2];
  //output : 4

  List<int> inputNum3 = [1];
  //output : 1

  Solution solution = Solution();

  print(solution.singleNumber(inputNum1));
  print(solution.singleNumber(inputNum2));
  print(solution.singleNumber(inputNum3));
}

class Solution {
  int singleNumber(List<int> nums) {
    List<int> list = [];
    for (var x in nums) {
      if (list.contains(x)) {
        list.remove(x);
      } else {
        list.add(x);
      }
    }
    return list.first;
  }
}
