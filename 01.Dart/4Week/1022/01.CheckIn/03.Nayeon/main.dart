// import 'package:intl/intl.dart';

// // 엘리서 체크인 시각 관련 클래스 정의
// enum Status {
//   CheckIn,
//   CheckOut,
// }

// // 엘리서 클래스를 정의
// class Eliser {
//   String name;
//   String className;
//   Status status;
//   DateTime? checkInTime;
//   DateTime? checkOutTime;
//   List<DateTime> lateCheckInTimes = []; // 지각 체크인 시간 기록

//   Eliser({required this.name, required this.className, required this.status});

//   // 체크인 시간 기록
//   void checkIn() {
//     checkInTime = DateTime.now();
//     status = Status.CheckIn; // 상태 업데이트
//     print("체크인 시각: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(checkInTime!)}");
//   }

//   // 체크아웃 시간 기록
//   void checkOut() {
//     checkOutTime = DateTime.now();
//     status = Status.CheckOut; // 상태 업데이트
//     print(
//         "체크아웃 시각: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(checkOutTime!)}");
//   }

//   // 지각 여부 판단
//   bool isLate(DateTime classStartTime) {
//     if (checkInTime == null) {
//       throw Exception("체크인 기록이 없습니다.");
//     }
//     bool late = checkInTime!.isAfter(classStartTime);
//     if (late) {
//       lateCheckInTimes.add(checkInTime!); // 지각 시간 기록
//     }
//     return late;
//   }

//   // 지각 3회 이상인 사람 리스트
//   static List<Eliser> filterLate3TimeMembers(List<Eliser> members) {
//     return members
//         .where((member) => member.lateCheckInTimes.length >= 3)
//         .toList();
//   }

//   // 특정 시간 이후 지각한 사람 리스트
//   static List<Eliser> filterLateMembers(List<Eliser> members) {
//     return members
//         .where((member) => member.lateCheckInTimes.isNotEmpty)
//         .toList();
//   }
// }

// void main() {
//   // 수업 시작 시간을 고정 (매일 오전 10시 10분)
//   DateTime today = DateTime.now();
//   DateTime classStartTime =
//       DateTime(today.year, today.month, today.day, 10, 10, 0); // 오전 10시 10분

//   // 멤버 리스트 및 수업명
//   List<String> memberNames = [
//     '김건호',
//     '김나연',
//     '유재원',
//     '이예지',
//     '이정건',
//     '이준영',
//     '임종섭',
//     '정찬호',
//     '조진혁'
//   ];

//   // Eliser 객체 리스트 생성
//   List<Eliser> membersOnTrack = memberNames
//       .map((name) =>
//           Eliser(name: name, className: 'Flutter', status: Status.CheckOut))
//       .toList();

// // 각 멤버 체크인 기록
//   for (var member in membersOnTrack) {
//     member.checkIn();
//     // 지각 여부 판단 + 체크인 안내
//     if (member.isLate(classStartTime)) {
//       print("Late CheckIn");
//     } else {
//       // 체크인 완료 메시지
//       print(
//           "${member.name} ${DateFormat('HH:mm').format(member.checkInTime!)} 체크인이 완료되었습니다.");
//     }
//   }

//   // 특정 시간 이후 지각한 사람 필터링
//   List<Eliser> lateMembers = Eliser.filterLateMembers(membersOnTrack);
//   print("10시 10분 이후 지각한 멤버: ${lateMembers.map((m) => m.name).join(', ')}");

//   // 한 달 동안 지각 3회 이상인 멤버 필터링
//   List<Eliser> frequentLateMembers =
//       Eliser.filterLate3TimeMembers(membersOnTrack);
//   print(
//       "한 달 동안 지각 3회 이상인 멤버: ${frequentLateMembers.map((m) => m.name).join(', ')}");
// }
