void main() {
  Solution solution = Solution();
  //String a = "3[a]2[bc]";
  //"aaabcbc"
  //String a = "3[a2[c]]";
  //"accaccacc"
  //String a = "2[abc]3[cd]ef";
  //"abcabccdcdcdef"
  //String a = "3[z]2[2[y]pq4[2[jk]e1[f]]]ef";
  //"zzzyypqjkjkefjkjkefjkjkefjkjkefyypqjkjkefjkjkefjkjkefjkjkefef"
  //"zzzyypqjkjkefjkjkefjkjkefjkjkefyypqjkjkefjkjkefjkjkefjkjkefef"
  //"zzzyypqjkjkefjkjkefjkjkefjkjkefyypqjkjkefjkjkefjkjkefjkjkefef"
  //String a = "abc3[cd]xyz";
  //"abccdcdcdxyz"
  //String a = "sd2[f2[e]g]i";
  //"sdfeegfeegi"
  //"sdfeegfeegi
  //String a = "2[2[2[b]]]";
  //"bbbbbbbb"
  //String a = "2[ab3[cd]]4[xy]";
  //"abcdcdcdabcdcdcdxyxyxyxy"
  //String a = "2[20[bc]31[xy]]xd4[rt]";
  //String a = "3[ab2[cd]e]fg10[h]";
  //"abcdcdeabcdcdeabcdcdefghhhhhhhhhh"
  String a = "2[2[y]pq4[2[jk]]e]";

  String result = solution.decodeString(a);
  print(result);
}

// class Solution {
//   String decodeString(String s) {
//     List<String> stack = [];

//     String result = "";
//     String temp = "";
//     int count = 0;

//     for (String char in s.split('')) {
//       if (RegExp(r'\d').hasMatch(char)) {
//         count = 10 * count + int.parse(char);
//       } else if (char == "[") {
//         stack.add(temp);
//         stack.add(count.toString());
//         temp = "";
//         count = 0;
//       } else if (char == "]") {
//         int repeatCount = int.parse(stack.removeLast());
//         String test = stack.removeLast();

//         temp = test + temp * repeatCount;
//       } else {
//         temp += char;
//       }
//     }

//     return temp;
//   }
// }

class Solution {
  String getTest(String temp2) {
    String temp = "";
    for (String charTest in temp2.split('')) {
      if (RegExp(r'[a-zA-Z]').hasMatch(charTest)) {
        return temp2.substring(temp2.indexOf(charTest)) * int.parse(temp2.substring(0, temp2.indexOf(charTest)));
      }
    }

    return temp;
  }

  String decodeString(String s) {
    List<String> stack = [];

    String result = "";
    String test = "";

    for (String char in s.split('')) {
      if (char == "[") {
        stack.add(test);
        test = "";
      } else if (char == "]") {
        if (int.tryParse(stack.last) != null) {
          String temp = test * int.parse(stack.removeLast());
          test = "";
          if (stack.isEmpty) {
            result += temp;
          } else {
            stack.add(temp);
          }
        } else {
          if (RegExp(r'\d').hasMatch(stack.last)) {
            int count = stack.last.split('').length;
            for (String element in stack.last.split('').toList()) {
              if (int.tryParse(element) != null) {
                if (count != stack.last.split('').toList().length) continue;
                String temp = stack.last.substring(0, stack.last.indexOf(element));
                //temp += test * int.parse(element);

                String temp2 = stack.last.substring(stack.last.indexOf(element));

                if (int.tryParse(temp2) != null) {
                  //if (RegExp(r'\d').hasMatch(temp2)) {
                  temp += test * int.parse(temp2);
                } else {
                  temp += getTest(temp2);
                }
                test = temp;
                stack.removeLast();
                stack.add(test);
                test = "";
              }
            }
          } else {
            if (test.isEmpty) {
              String last = stack.removeLast();
              if (int.tryParse(stack.last) != null) {
                stack.add(last * int.parse(stack.removeLast()));
              } else {
                if (RegExp(r'\d').hasMatch(stack.last)) {
                  stack.add(last);
                } else {
                  String temp = stack.removeLast() + last;
                  if (int.tryParse(stack.last) != null) {
                    stack.add(temp * int.parse(stack.removeLast()));
                  } else {
                    stack.add(stack.removeLast() + temp);
                  }
                }
              }
            } else {
              String last = stack.removeLast();
              if (RegExp(r'\d').hasMatch(stack.last)) {
                String temp = last + test;
                if (int.tryParse(stack.last) != null) {
                  temp = temp * int.parse(stack.removeLast());
                }
                stack.add(temp);
              } else {
                stack.add(last + test);
              }
              test = "";
            }
          }
        }
      } else {
        test += char;
      }
    }

    String test2 = "";
    if (!stack.isEmpty) {
      for (String element in stack.reversed.toList()) {
        if (int.tryParse(element) != null) {
          String temp = test2 * int.parse(stack.last);
          stack.removeLast();
          if (stack.isEmpty) {
            result += temp;
            test2 = "";
          } else {
            test2 = temp;
          }
        } else {
          if (RegExp(r'\d').hasMatch(element)) {
            for (String value in element.split('')) {
              if (int.tryParse(value) != null) {
                String temp = element.substring(0, element.indexOf(value));
                temp += test2 * int.parse(value);
                test2 = temp;
                stack.removeLast();
              }
            }
          } else {
            test2 = element + test2;
            stack.removeLast();
          }
        }
      }
    }

    if (!test2.isEmpty) {
      result += test2;
    }

    if (!test.isEmpty) {
      result += test;
    }

    return result;
  }
}
