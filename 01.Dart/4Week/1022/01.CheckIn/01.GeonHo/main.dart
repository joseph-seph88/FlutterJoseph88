/*

엘리서 여러분의 체크인 앱 개발

엘리서 체크인 시각 관련 클래스 정의
-

 */

import 'dart:math';

enum Status { CheckIn, CheckOut }

// 1. 엘리서 클래스를 정의
class Eliser {
  final String name;
  final String className;
  late Status status;
  late DateTime checkInTime;
  late DateTime checkOutTime;

  Eliser({required this.name, required this.className});

  void checkIn(DateTime dateTime) {
    this.status = Status.CheckIn;
    this.checkInTime = dateTime;
  }

  void checkOut(DateTime dateTime) {
    this.status = Status.CheckOut;
    this.checkOutTime = dateTime;
  }
}

// 2. 엘리서의 체크인 시각을 입력하는 클래스를 정의
class Checkin {
  // 체크인/체크아웃

  List<Eliser> getLateEliser(List<Eliser> eliserList, DateTime dateTime) {
    return eliserList.where((eliser) => eliser.checkInTime.isAfter(dateTime)).toList();
  }

  Map<String, List<Eliser>> getLateEliserInMonth(List<Eliser> eliserList, int lateCount) {
    Map<String, List<Eliser>> lateEliser = {};

    for (Eliser eliser in eliserList) {
      DateTime checkInTime = eliser.checkInTime;
      DateTime checkTime = DateTime(checkInTime.year, checkInTime.month, checkInTime.day, checkInTime.hour, 10);

      if (checkInTime.isAfter(checkTime)) {
        lateEliser[eliser.name] ??= [];
        lateEliser[eliser.name]!.add(eliser);
      }
    }

    lateEliser.removeWhere((name, elisers) => elisers.length < lateCount);

    return lateEliser;
  }
}

void main() {
  List<Eliser> eliserList = [];
  List<String> members = ["김건호", "이정건", "이준영", "정찬호", "이예지", "김나연", "임종섭", "조진혁", "유재원"];

  DateTime today = DateTime.now();
  DateTime startDay = today.subtract(Duration(days: 30));

  for (DateTime dateTime = startDay; dateTime.isBefore(today) | dateTime.isAtSameMomentAs(today); dateTime = dateTime.add(Duration(days: 1))) {
    for (String member in members) {
      Eliser eliser = Eliser(name: member, className: "Flutter3기");
      eliser.checkIn(DateTime(dateTime.year, dateTime.month, dateTime.day, 10, Random().nextInt(12)));
      eliserList.add(eliser);
    }
  }

  // report method
  // class3 멤버중에서 특정시간 이후 지각한사람만 뽑아야 할떄 호출하는 메서드
  Checkin checkin = Checkin();

  DateTime dateTime = DateTime(2024, 10, 23, 10, 10);

  List<Eliser> lateEliser = checkin.getLateEliser(eliserList, dateTime);

  print(lateEliser.map((eliser) => "${eliser.name}-${eliser.className} ${eliser.checkInTime} 입실").join('\n'));

  Map<String, List<Eliser>> late = checkin.getLateEliserInMonth(eliserList, 3);

  late.forEach((name, elisers) {
    print("$name: ${elisers.length}회\n${elisers.map((eliser) => eliser.checkInTime).join('\n')}\n");
  });
}
