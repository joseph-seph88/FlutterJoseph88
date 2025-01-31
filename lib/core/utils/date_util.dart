extension DateTimeExtensions on DateTime {
  String toElapsedTimeString() {
    final now = DateTime.now();
    final dif = now.difference(this);

    if (dif.inMinutes < 1) {
      return '방금 전';
    } else if (dif.inHours < 1) {
      return '${dif.inMinutes}분 전';
    } else if (dif.inDays < 1) {
      return '${dif.inHours}시간 전';
    } else if (dif.inDays < 7) {
      return '${dif.inDays}일 전';
    } else if (dif.inDays < 30) {
      return '${dif.inDays ~/ 7}주 전';
    } else if (dif.inDays < 365) {
      return '${dif.inDays ~/ 30}달 전';
    } else {
      return '$year-$month-$day';
    }
  }

  String toDateOnlyString() {
    return '$year년 $month월 $day일';
  }

  String toTimeOnlyString() {
    String ap = hour < 12 ? '오전' : '오후';
    String hh = hour == 0 ? '12' : hour > 12 ? '${hour % 12}' : '$hour';
    String mm = minute < 10 ? '0$minute' : '$minute';

    return '$ap $hh:$mm';
  }

  bool isTimeSame(DateTime time) {
    return year == time.year &&
        month == time.month &&
        day == time.day &&
        hour == time.hour &&
        minute == time.minute;
  }
}
