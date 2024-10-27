
class LongestSubstring{
  final List<String> _stringList = [];
  int _maxLength = 0;

  void maxLengthFunction(String inputString){
    for(int i=0; i<inputString.length; i++){
      int j = 0;
      while(_stringList.contains(inputString[i])){
        _stringList.remove(inputString[j]);
        j ++;
      }
      _stringList.add(inputString[i]);
      _maxLength = _maxLength > _stringList.length ? _maxLength : _stringList.length;
    }
  }

  int getMaxLength(){
    return _maxLength;
  }

}

void main(){
  String inputString = "pwwkew";
  // String inputString2 = "abcabcabbad";

  LongestSubstring longestSubstring = LongestSubstring();
  longestSubstring.maxLengthFunction(inputString) ;

  print(longestSubstring.getMaxLength());
}
