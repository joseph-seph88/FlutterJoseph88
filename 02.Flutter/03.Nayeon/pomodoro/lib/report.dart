import 'package:flutter/material.dart';
import 'package:pomodoro/color_styles.dart';
import 'time_storage.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TimeStorage timeStorage = TimeStorage();
  int todayStudySeconds = 0;
  int accumulatedStudySeconds = 0;
  int cycleCount = 0;
  List<String> logs = []; // 로그 리스트 추가

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 데이터를 SharedPreferences에서 불러오는 메서드
  Future<void> _loadData() async {
    todayStudySeconds = await timeStorage.loadTodayTime();
    accumulatedStudySeconds = await timeStorage.loadAccumulatedTime();
    cycleCount = await timeStorage.loadCycleCount();
    logs = await timeStorage.loadLogs(); // 로그 불러오기
    setState(() {}); // 데이터 로드 후 화면 업데이트
  }

  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: yellowstyle6,
        titleTextStyle: TextStyle(color: yellowstyle6, fontSize: 24),
        title: Text(
          "Study Log",
        ),
        backgroundColor: yellowstyle3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "오늘의 집중시간",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              formatTime(todayStudySeconds),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 30),
            Text(
              "애그타임과 함께 집중한 시간",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              formatTime(accumulatedStudySeconds),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 30),
            Divider(),
            Text(
              "로그 기록",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Expanded(
              child: logs.isEmpty
                  ? Center(child: Text("저장된 로그가 없습니다."))
                  : ListView.builder(
                      reverse: true, // 최신순으로 정렬
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(logs[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
