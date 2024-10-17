// 오늘의 알고리즘

// 피자집
// 고객이 원하는 토핑을 골라 주문하는 피자집의 주문 시스템을 만든다
// 비트마스크를 이용해 표현하자

// 20가지 토핑
// 함수: 토핑 넣기/빼기
// 스무종류의 원소만 가지는 집합

// 토핑을 전부 올린 피자를 어떻게 표현할까?
// 원소를 추가하는 메서드
// 원소가 있는지 확인하는 메서드
// 원소를 빼는 메서드

// (클래스로 만드셔도되고 그냥 함수로 구현해도됩니다)

class PizzaOrder {
  int toppings = 0; // 토핑을 저장할 비트마스크 (처음엔 아무 토핑도 없음)

  // 토핑 추가
  void addTopping(int toppingIndex) {
    toppings |= (1 << toppingIndex); // 해당 위치의 비트를 1로 만듦
  }

  // 토핑 제거
  void removeTopping(int toppingIndex) {
    toppings &= ~(1 << toppingIndex); // 해당 위치의 비트를 0으로 만듦
  }

  // 토핑이 있는지 확인
  bool hasTopping(int toppingIndex) {
    return (toppings & (1 << toppingIndex)) != 0; // 해당 위치의 비트가 1인지 확인
  }

  // 현재 토핑 상태 출력 (디버깅용)
  void printToppings() {
    print(toppings.toRadixString(2).padLeft(20, '0')); // 2진수로 출력 (토핑 상태)
  }
}

void main() {
  PizzaOrder myPizza = PizzaOrder();
}

// 비트마스크(Bitmask)는 비트 연산을 통해 여러 개의 상태나 옵션을 하나의 정수로 표현하는 기법
// 장점 : 메모리절약, 빠른연산, 코드간결화

// 연산기호
// 비트 OR (|): 비트를 켜기
// 예: num |= (1 << i);

// 비트 AND (&): 비트를 확인
// 예: (num & (1 << i)) != 0;

// 비트 AND + NOT (& ~): 비트를 끄기
// 예: num &= ~(1 << i);

// 비트 XOR (^): 비트를 토글 (0 → 1, 1 → 0)
// 예: num ^= (1 << i);
 
// (1 << i)는 비트 시프트 연산, 1을 왼쪽으로 i만큼 이동시킨다.
// 즉, (1 << i)는 i번째 비트를 1로 만든다
