class RomanToInteger{
  Map<String, int> romMap = {
    "I": 1,
    "V": 5,
    "X": 10,
    "L": 50,
    "C": 100,
    "D": 500,
    "M": 1000
  };

  int romIntConvert(String inputRom) {
    int prev = 0;
    int result = 0;
    for(int i=inputRom.length-1; i>=0; i--){
      int curr = romMap[inputRom[i]]!;
      if(curr >= prev) result += curr;
      else result -= curr;
      prev = curr;
    }
    return result;
  }
}

void main() {
  RomanToInteger romanToInteger = RomanToInteger();
  String inputRom = "VI";
  print(romanToInteger.romIntConvert(inputRom));
}