
class Solution {
  int singleNumber(List<int> nums) {
    Map<int, int> numberCount = {};

    for(int number in nums){
      numberCount[number] = (numberCount[number] ?? 0) + 1;
    }

    int result = 0;

    for(int number in numberCount.keys){
      if(numberCount[number] == 1){
        result = number;
      }
    }

    return result;
  }
}

void main(){
  List<int> inputNums1 = [2, 2, 1];
  List<int> inputNums2 = [4,1,2,1,2];
  List<int> inputNums3 = [3,2,3,4,5,1,2,4,5,3,1,6];

  Solution solution = Solution();

  int ouputNums1 = solution.singleNumber(inputNums3);
  print(ouputNums1);
}


// class Solution {
//   int singleNumber(List<int> nums) {
//     int result = 0;
//     for(int number in nums){
//       result ^= number;
//     }
//     return result;
//   }
// }
//
// void main(){
//   List<int> inputNums1 = [2, 2, 1];
//   List<int> inputNums2 = [4,1,2,1,2];
//   List<int> inputNums3 = [3,2,3,4,5,1,2,4,5];
//
//   Solution solution = Solution();
//
//   int ouputNums1 = solution.singleNumber(inputNums3);
//   print(ouputNums1);
// }