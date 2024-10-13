void main() {
  List<int> input1 = [1, 2, 3, 1];
  List<int> input2 = [1, 2, 3, 4];
  List<int> input3 = [1, 1, 1, 3, 3, 4, 3, 2, 4, 2];

  Solution solution = Solution();

  print(solution.containsDuplicate(input1));
  print(solution.containsDuplicate(input2));
  print(solution.containsDuplicate(input3));

  String a = "Protect Test";
}

class Solution {
  bool containsDuplicate(List<int> nums) {
    Set<int> set = {};

    for (int num in nums) {
      if (set.contains(num)) {
        return true;
      }
      set.add(num);
    }

    return false;
  }
}
