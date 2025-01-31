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
}