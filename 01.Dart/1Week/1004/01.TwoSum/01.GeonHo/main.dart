void main() {
  Solution solution = Solution();
  List<int> result = solution.twoSum([3, 3], 6);

  print(result);
}

class Solution {
  List<int> twoSum(List<int> nums, int target) {
    for (int firstLoopIndex = 0; firstLoopIndex < nums.length; firstLoopIndex++) {
      for (int secondLoopIndex = 1; secondLoopIndex < nums.length; secondLoopIndex++) {
        if (firstLoopIndex != secondLoopIndex && target - nums[firstLoopIndex] == nums[secondLoopIndex]) {
          return [firstLoopIndex, secondLoopIndex];
        }
      }
    }
    return [];
  }
}
