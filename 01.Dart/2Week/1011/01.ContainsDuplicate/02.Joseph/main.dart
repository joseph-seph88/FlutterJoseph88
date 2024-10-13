// Given an integer array nums, return true if any value appears at least twice
// in the array, and return false if every element is distinct.
//
// Example 1:
// Input: nums = [1,2,3,1]
// Output: true


import 'dart:io';

bool isDuplicate(List<int> arr){
  for(int i=0; i<arr.length; i++){
    for(int j=i+1; j<arr.length; j++){
      if(arr[i] == arr[j]){
        return true;
      }
    }
  }
  return false;
}

List<int> convertStringListInt(String input){
  String input2 = input.replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
  List<String> inputNumber = input2.split(',');
  List<int> result = inputNumber.map((element) => int.parse(element)).toList();
  return result;
}

void main(){
  stdout.write('정수 입력: ');
  String? input = stdin.readLineSync();
  if(input !=null){
    List<int>arr = [];
    arr = convertStringListInt(input);

    print(isDuplicate(arr));

  }
}