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
    int count = 0; // 비-0 요소의 개수를 세기 위한 변수

    // 배열을 순회하여 비-0 요소를 앞으로 이동
    for (int i = 0; i < nums.length; i++) {
      if (nums[i] != 0) {
        // 현재 요소가 비-0이면
        nums[count] = nums[i]; // 비-0 요소를 앞쪽으로 이동
        count++; // 비-0 요소의 개수를 증가시킴
      }
    }

    // 비-0 요소 뒤에 0을 채움
    for (int i = count; i < nums.length; i++) {
      nums[i] = 0;
    }
  }
}
