void main() {
  Solution solution = Solution();
  String answer = solution.solution("", "", "", "", ["", ""]);
  // String answer = solution.solution("34:33", "13:00", "00:55", "02:55", ["next", "prev"]);
  // String answer = solution.solution("10:55", "00:05", "00:15", "06:55", ["prev", "next", "next"]);
  // String answer = solution.solution("07:22", "04:05", "00:15", "04:07", ["next"]);
  print(answer);
}

class Solution {
  String solution(String video_len, String pos, String op_start, String op_end, List<String> comands) {
    DateTime dt_video_len = SetDateTime(video_len);
    DateTime dt_pos = SetDateTime(pos);

    for (String comand in comands) {
      CheckOpening(dt_pos, op_start, op_end);

      switch (comand) {
        case "prev":
          dt_pos = dt_pos.isBefore(DateTime(2024, 1, 1, 0, 0, 10)) ? DateTime(2024, 1, 1, 0, 0, 0) : dt_pos.subtract(Duration(seconds: 10));
          break;
        case "next":
          dt_pos = dt_pos.isAfter(dt_video_len) ? dt_video_len : dt_pos.add(Duration(seconds: 10));
          break;
      }
      CheckOpening(dt_pos, op_start, op_end);
    }

    String answer = dt_pos.minute.toString().padLeft(2, "0") + ":" + dt_pos.second.toString().padLeft(2, "0");

    return answer;
  }

  DateTime SetDateTime(String dateTime) {
    int minute = int.parse(dateTime.split(':')[0]);
    int second = int.parse(dateTime.split(':')[1]);

    return DateTime(2024, 1, 1, 0, minute, second);
  }

  void CheckOpening(DateTime dt_pos, String op_start, String op_end) {
    DateTime dt_op_start = SetDateTime(op_start);
    DateTime dt_op_end = SetDateTime(op_end);

    if ((dt_pos.isAfter(dt_op_start) || dt_pos.isAtSameMomentAs(dt_op_start)) && (dt_pos.isBefore(dt_op_end) || dt_pos.isAtSameMomentAs(dt_op_end))) {
      dt_pos = dt_op_end;
    }
  }
}
