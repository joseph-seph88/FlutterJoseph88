// Given an integer array nums, move all 0's to the end of it while maintaining
// the relative order of the non-zero elements.

// Note that you must do this in-place without making a copy of the array.

// Example 1:
// Input: nums = [0,1,0,3,12]
// Output: [1,3,12,0,0]

// Example 2:
// Input: nums = [0]
// Output: [0]

// Constraints:
// 1 <= nums.length <= 104
// -231 <= nums[i] <= 231 - 1

void main() {
  //output [1, 3, 12, 0, 0];
  List<int> inputNums1 = [0, 1, 0, 3, 12];

  //output [0]
  List<int> inputNums2 = [0];

  Solution solution = Solution();

  solution.moveZeroes(inputNums1);
  print(inputNums1);

  solution.moveZeroes(inputNums2);
  print(inputNums2);
}

class Solution {
  void moveZeroes(List<int> nums) {
    // 비 0 요소를 옮길 위치를 추적할 인덱스
    int index = 0;

    // 배열을 순차적으로 탐색하면서 0이 아닌 요소들을 앞쪽으로 이동
    for (int i = 0; i < nums.length; i++) {
      if (nums[i] != 0) {
        nums[index] = nums[i];
        index++;
      }
    }

    // 남은 부분을 모두 0으로 채움
    for (int i = index; i < nums.length; i++) {
      nums[i] = 0;
    }
  }
}
