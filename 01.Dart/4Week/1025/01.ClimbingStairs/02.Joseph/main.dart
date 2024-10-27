int climbingStairs(int n){
  if(n == 0 || n == 1) return 1;
  int prev = 0, curr = 1, result = 0;

  for(int i=2; i<=n; i++){
    result = curr + prev;
    prev = curr;
    curr = result;
  }
  return result;
}

void main(){
  int n = 5;
  print(climbingStairs(n));
}



// import 'dart:math';
//
// int climbingStairs(int n){
//   if (n == 0 || n == 1) return 1;
//
//   double phi = (1 + sqrt(5)) / 2;
//   double psi = (1 - sqrt(5)) / 2;
//
//   int result = ((pow(phi, n+1) - pow(psi, n+1)) / sqrt(5)).round();
//   return result;
// }
//
// void main(){
//   int n = 3;
//   print(climbingStairs(n));
// }