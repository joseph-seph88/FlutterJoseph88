// wallet	  bill	      result
// [30, 15]	[26, 17]	  1
// [50, 50]	[100, 241]	4
void main() {
  Solution solution = Solution();

  //List<int> wallet = [30, 15];
  List<int> wallet = [50, 50];
  //List<int> bill = [26, 17];
  List<int> bill = [100, 241];

  print(solution.solution(wallet, bill));
}

class Solution {
  int solution(List<int> wallet, List<int> bill) {
    int answer = 0;

    while (!isFit(wallet, bill)) {
      bill = foldBill(bill);
      answer++;
    }

    return answer;
  }

  bool isFit(List<int> wallet, List<int> bill) {
    return (wallet[0] >= bill[0] && wallet[1] >= bill[1]) || (wallet[0] >= bill[1] && wallet[1] >= bill[0]);
  }

  List<int> foldBill(List<int> bill) {
    if (bill[0] >= bill[1]) {
      return [bill[0] ~/ 2, bill[1]];
    } else {
      return [bill[0], bill[1] ~/ 2];
    }
  }
}
