/*
피자집 - 고객이 원하는 토핑을 골라 주문하는 피자집의 주문 시스템을 만든다
비트마스크를 이용해 표현하자

20가지 토핑
함수: 토핑 넣기/빼기
스무종류의 원소만 가지는 집합

토핑을 전부 올린 피자를 어떻게 표현할까?
원소를 추가하는 메서드
원소가 있는지 확인하는 메서드
원소를 빼는 메서드

비트마스크 : 정수형의 변수로 10진수(0 ~ 9)를 이용하여 각 비트의 특정상태를 나타냅니다.
주로 집합을 표현하거나 플래그(flag)를 관리하는 데 사용됩니다.
00000001 (1): 상태 1
00000010 (2): 상태 2
00000100 (4): 상태 3
00001000 (8): 상태 4
00010000 (16): 상태 5
00100000 (32): 상태 6
01000000 (64): 상태 7
10000000 (128): 상태 8 

조건연산을 활용하여 연산함
* 특정 비트를 설정할 때는 OR 연산을 사용 *
mask = 0  # 초기 상태
mask |= 1  # 상태 1 추가(0001)
* 특정 비트를 해제할 때는 AND NOT 연산을 사용 *
mask &= ~1  # 상태 1 제거
* 특정 비트가 설정되어 있는지 확인할 때는 AND 연산을 사용 *
if mask & 4:  # 상태 3이 설정되어 있는지 확인
* 비트마스크의 현재 상태를 출력
print(bin(mask))  # 2진수 형태로 출력
* 최종 상태 출력
  print("최종 비트마스크: ${mask.toRadixString(2)}"); // 2진수로 출력

 */
// 0b0001은 이진수 리터럴을 나타내는 형식이야. 여기서 0b는 이 숫자가 이진수임을 나타내고, 뒤에 오는 숫자는 비트의 값을 표현해.
// 내가 생각하는 출력 값 : 0b11111111111111111111
// 재료 : 치즈, 페퍼로니, 새우, 고구마, 감자, 올리브, 양파, 피망, 불고기, 옥수수, 파인애플, 미트볼, 버섯, 베이컨, 김치, 스테이크, 치킨
// 치즈크러스트, 고구마무스, 할라피뇨
/*
   스케치 - 
   맵으로 키(메뉴)-값(상태) 쌍을 연결해주고
   문자받고 정수로 변경하여 if문으로 추가
   빼는지 확인
   출력
  
 */

import 'dart:io';

Map<String, int> PizzaMenu = {
  '치즈': 1, // 00000001
  '페퍼로니': 2, // 00000010
  '새우': 4, // 00000100
  '고구마': 8, // 00001000
  '감자': 16, // 00010000
  '올리브': 32, // 00100000
  '양파': 64, // 01000000
  '피망': 128, // 10000000
  '불고기': 256, // 100000000
  '옥수수': 512, // 1000000000
  '파인애플': 1024, // 10000000000
  '미트볼': 2048, // 100000000000
  '버섯': 4096, // 1000000000000
  '베이컨': 8192, // 10000000000000
  '김치': 16384, // 100000000000000
  '스테이크': 32768, // 1000000000000000
  '치킨': 65536, // 10000000000000000
  '치즈크러스트': 131072, // 100000000000000000
  '고구마무스': 262144, // 1000000000000000000
  '할라피뇨': 524288, // 10000000000000000000
};

int mask = 0; // 피자 상태를 저장할 비트마스크 초기화

void main() {
  while (true) {
    print(
        "피자의 토핑을 추가하거나 제거하세요 (예: '치즈', '페퍼로니', '-치즈'로 입력하여 제거, '종료'로 입력하면 종료 됩니다.): ");
    String? input = stdin.readLineSync();

    if (input != null && input == '종료') {
      break; // 종료
    }

    if (input != null && PizzaMenu.containsKey(input)) {
      // 유효한 토핑을 추가
      int toppingValue = PizzaMenu[input]!;
      mask |= toppingValue; // 비트마스크에 추가
      print("$input 토핑이 추가되었습니다.");
    } else if (input != null && input.startsWith('-')) {
      String toppingToRemove = input.substring(1).trim(); // '-' 기호 제거
      if (PizzaMenu.containsKey(toppingToRemove)) {
        int toppingValue = PizzaMenu[toppingToRemove]!;
        mask &= ~toppingValue; // 비트마스크에서 제거
        print("$toppingToRemove 토핑이 제거되었습니다.");
      } else {
        print("유효하지 않은 토핑입니다: $toppingToRemove"); // 오류 메시지 개선
      }
    } else {
      print("유효하지 않은 입력입니다."); // 다른 값 출력
    }
  }
  // 현재 비트마스크 상태 출력
  print("현재 비트마스크 (10진수): $mask");
  print("현재 비트마스크 (2진수): ${mask.toRadixString(2)}");

  // 최종 상태 출력
  print("최종 비트마스크 (10진수): $mask");
  print("최종 비트마스크 (2진수): ${mask.toRadixString(2)}");
}
