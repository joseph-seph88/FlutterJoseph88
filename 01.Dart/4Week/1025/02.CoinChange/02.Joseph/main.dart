
int coinChange(List<int> coins, int amount){
  if(amount <= 0) return 0;
  int result = 0;
  coins.sort();
  int index = coins.length-1;

  for(int i=index; i>=0; i--){
    if(amount <= 0) break;
    result += amount ~/ coins[i];
    amount %= coins[i];
  }
  return amount == 0 ? result : -1;
}

void main(){
  List<int> coins = [1,2,5];
  int amount = 11;
  print(coinChange(coins, amount));
}