
class Solution {
  final List<int> _wallet = [50, 50];
  final List<int> _bill = [100, 241];
  int _answer = 0;

  bool canIn(List<int> wallet, List<int> bill) {
    bool result = (bill[0] <= wallet[0] && bill[1] <= wallet[1]) ||
        (bill[0] <= wallet[1] && bill[1] <= wallet[0]);
    return result;
  }

  void foldBill(List<int> bill) {
    if (bill[0] > bill[1]) {
      bill[0] = bill[0] ~/ 2;
    } else {
      bill[1] = bill[1] ~/ 2;
    }
  }

  void setBillAnswer() {
    while (!canIn(_wallet, _bill)) {
      foldBill(_bill);
      _answer++;
    }
  }

  void printAnswer() {
    print("접 수 : $_answer");
  }
}

void main() {
  Solution solution = Solution();
  solution.setBillAnswer();
  solution.printAnswer();
}
