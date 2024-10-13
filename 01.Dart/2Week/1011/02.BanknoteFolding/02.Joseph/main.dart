// 지갑의 크기가 30 * 15이고 지폐의 크기가 26 * 17이라면
// 한번 반으로 접어 13 * 17 크기로 만든 뒤 90도 돌려서 지갑에 넣을 수 있습니다.
//
// 지폐를 접을 때는 다음과 같은 규칙을 지킵니다.
// 지폐를 접을 때는 항상 길이가 긴 쪽을 반으로 접습니다.
// 접기 전 길이가 홀수였다면 접은 후 소수점 이하는 버립니다.
// 접힌 지폐를 그대로 또는 90도 돌려서 지갑에 넣을 수 있다면 그만 접습니다.
// 지갑의 가로, 세로 크기를 담은 정수 리스트 wallet과 지폐의 가로, 세로 크기를 담은 정수 리스트 bill가 주어질 때,
// 지갑에 넣기 위해서 지폐를 최소 몇 번 접어야 하는지 return하도록 solution함수를 완성해 주세요.

// wallet	bill	result
// [30, 15]	[26, 17]	1
// [50, 50]	[100, 241]	4


import 'dart:io';

int solution(List<int> wallet, List<int> bill){
  int answer = 0;

  bool canIn(List<int> wallet, List<int> bill){
    bool result = (bill[0] <= wallet[0] && bill[1] <= wallet[1]) || (bill[0] <= wallet[1] && bill[1] <= wallet[0]);
    return result;
  }

  void foldBill(List<int> bill){
    if(bill[0] > bill[1]){
      bill[0] = bill[0] ~/ 2;
    }else{
      bill[1] = bill[1] ~/ 2;
    }
  }

  while(!canIn(wallet, bill)){
    foldBill(bill);
    answer++;
  }

  return answer;
}

void main(){
  List<int> wallet = [50, 50]	;
  List<int> bill = [100, 241];
  print('몇 번? ${solution(wallet, bill)}');
}