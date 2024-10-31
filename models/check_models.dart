class NameModel {
  final int? id;
  final String name;
  final String time;
  final int lateCount;

  NameModel({
    this.id,
    required this.name,
    required this.time,
    required this.lateCount,
  });

  Map<String, dynamic> dbMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'lateCount':lateCount,
    };
  }

  factory NameModel.fromMap(Map<String, dynamic> map) {
    return NameModel(
      id: map['id'],
      name: map['name'],
      time: map['time'],
      lateCount: map['lateCount'],
      //맵 타입으로 온 데이터를 키값을 써서 밸류값을 가져옴
      //예를 들어 {'id': 1, 'name': 'Joseph'} 이런 데이터 형식이 들어오며 키-밸류 사용
    );
  }
}
