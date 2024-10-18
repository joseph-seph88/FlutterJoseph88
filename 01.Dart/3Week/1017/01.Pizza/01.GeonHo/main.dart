enum PizzaTopping {
  pepperoni,
  mushrooms,
  onions,
  sausage,
  bacon,
  extraCheese,
  blackOlives,
  greenPeppers,
  pineapple,
  spinach,
  tomatoes,
  jalapenos,
  garlic,
  basil,
  artichokes,
  anchovies,
  fetaCheese,
  chicken,
  shrimp,
  bellPeppers,
}

class PizzaOrder {
  int toppingsMask = 0; // 비트마스크 초기화 (0은 아무 토핑도 없음)

  // 토핑 추가: 해당 인덱스의 비트를 1로 설정
  void addTopping(PizzaTopping topping) {
    toppingsMask |= (1 << topping.index);
  }

  // 토핑 제거: 해당 인덱스의 비트를 0으로 설정
  void removeTopping(PizzaTopping topping) {
    toppingsMask &= ~(1 << topping.index);
  }

  // 특정 토핑이 있는지 확인: 해당 인덱스의 비트가 1인지 확인
  bool hasTopping(PizzaTopping topping) {
    return (toppingsMask & (1 << topping.index)) != 0;
  }

  // 현재 선택된 토핑 표시
  List<String> showToppings() {
    List<String> toppings = [];
    for (PizzaTopping topping in PizzaTopping.values) {
      if (hasTopping(topping)) {
        toppings.add(topping.toString().split('.').last); // 토핑 이름만 추가
      }
    }
    return toppings;
  }
}

void main() {
  PizzaOrder order = PizzaOrder();

  // 토핑 추가
  order.addTopping(PizzaTopping.pepperoni); // Pepperoni 추가
  order.addTopping(PizzaTopping.sausage); // Sausage 추가

  print("현재 선택된 토핑: ${order.showToppings()}");

  // 토핑 제거
  order.removeTopping(PizzaTopping.pepperoni); // Pepperoni 제거

  print("현재 선택된 토핑: ${order.showToppings()}");

  // 특정 토핑 확인
  print("Sausage이 포함되어 있나요? ${order.hasTopping(PizzaTopping.sausage)}");
}
