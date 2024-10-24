import 'dart:io';

void main() {
  int start = getInput("첫 달에 저축하는 금액을 입력하세요.", 0, 99);
  int before = getInput("두번째 달부터 70만원 이상 모일 때까지 매월 저축하는 금액을 입력하세요.", 1, 25);
  int after = getInput("100만원 이상 모일 때까지 매월 저축하는 금액을 입력하세요.", before, 25);

  int money = start;
  int month = 1;

  while (money < 70) {
    money += before;
    month++;
  }

  while (money < 100) {
    money += after;
    month++;
  }

  print("100만원 이상을 모을 때까지 걸리는 개월 수는 $month 개월 입니다.");
}

int getInput(String contents, int min, int max) {
  while (true) {
    print(contents);
    String? input = stdin.readLineSync();

    if (input == null || int.tryParse(input) == null) {
      print("유효한 숫자를 입력하세요.");
      continue;
    }

    int value = int.parse(input);
    if (value < min || value > max) {
      print("금액은 $min 보다 크고 $max 보다 작아야 합니다.");
      continue;
    }

    return value;
  }
}
