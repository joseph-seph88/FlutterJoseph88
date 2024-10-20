// Given an integer array nums, move all 0's to the end of
// it while maintaining the relative order of the non-zero elements.
//
// Note that you must do this in-place without making a copy of the array.
//
// Example 1:
//
// Input: nums = [0,1,0,3,12]
// Output: [1,3,12,0,0]
// Example 2:
//
// Input: nums = [0]
// Output: [0]

void main(){
  List<int>InputNums = [0, 1, 0, 2, 0, 4, 3, 12];
  int index = InputNums.length;

  for(int i=0; i<index; i++){
    if(InputNums[i] == 0){
      InputNums.removeAt(i);
      InputNums.add(0);
    }
  }
  print(InputNums);
}