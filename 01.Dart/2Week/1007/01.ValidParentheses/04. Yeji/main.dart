/*
    Todo : Map을 만들어 매치되는 값을 생성 - 값을 확인하고 넣을 stack 생성 - 문자열을 하나씩 나눠서 값을 하나씩 대조해서 stack에다가 넣기 
*/
class Solution {
  bool isValid(String s) {
// 's'를 통해서 문자열이 들어올건데 이 문자열을 맞는지 안맞는지 확인할거야. 그리고 그걸 'isValid'라는 함수(isValid는 참과 거짓을 나누는 함수야)
    final Map<String, String> openclose = {
      '(': ')',
      '{': '}',
      '[': ']',
    };

// [];이 들어있는 문자열 stack 리스트 생성
    List<String> stack = [];

// s에 들어 온 문자열 char을 다 구분해서 반복할건데
// (여기에서 String char 정의)
    for (String char in s.split('')) {
// char에 들어가는 key가 openclose에 들어가있어?
      if (openclose.containsKey(char)) {
        stack.add(
            char); // 만약에 char이 openclose에 들어가 있는 값과 똑같은게 있으면 stack에다가 char을 넣어줘
      } else {
        // (flase일 경우)
// Stack이 비어있거나 char이랑 openclose 스택의 마지막 요소를 제거하면서 꺼낸게 같지않다면
        if (stack.isEmpty || openclose[stack.removeLast()] != char) {
          return false; // flase를 출력
        }
      }
    }

// if에서 결과값이 안 나올 때는 stack이 비어있는지 여부를(true/flase) isaValid에 반환값 return
    return stack.isEmpty;
// 출력 시 print(isValid); // 출력 : true / flase
  }
}
