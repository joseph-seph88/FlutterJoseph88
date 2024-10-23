class LongestSubstring{
  final List<String> _stringList = [];
  final int _j = 0;
  int _maxLength = 0;

  void maxLengthFunction(String inputString){
    for(int i=0; i<inputString.length; i++){
      if(_stringList.contains(inputString[i])){
        _stringList.removeAt(_j);
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
  String inputString = "abcabcbb";
  LongestSubstring longestSubstring = LongestSubstring();
  longestSubstring.maxLengthFunction(inputString) ;

  print(longestSubstring.getMaxLength());
}
