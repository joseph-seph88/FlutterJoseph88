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
    // List<int> zeroList = List.filled(nums.length, 0);

    // int index = 0;
    // for (int num in nums) {
    //   if (num != 0) {
    //     zeroList[index] = num;
    //     index++;
    //   }
    // }
    // //nums = zeroList;
    // for (int i = 0; i < nums.length; i++) {
    //   nums[i] = zeroList[i];
    // }

    // int index = 0;
    // for (int num in nums) {
    //   if (num != 0) {
    //     nums[index] = num;
    //     index++;
    //   }
    // }

    // for (int i = index; i < nums.length; i++) {
    //   nums[i] = 0;
    // }

    int zeroIndex = 0;
    for (int index = 0; index < nums.length; index++) {
      if (nums[index] != 0) {
        if (zeroIndex != index) {
          nums[zeroIndex] = nums[index];
          nums[index] = 0;
        }
        zeroIndex++;
      }
    }
  }
}
