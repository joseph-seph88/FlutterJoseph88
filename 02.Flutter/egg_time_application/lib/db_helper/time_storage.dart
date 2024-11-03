import 'package:shared_preferences/shared_preferences.dart';

class TimeStorage {
  Future<void> saveAccumulatedTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accumulatedStudySeconds', time);
  }

  Future<int> loadAccumulatedTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('accumulatedStudySeconds') ?? 0;
  }

  Future<void> saveTodayTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('todayStudySeconds', time);
  }

  Future<int> loadTodayTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('todayStudySeconds') ?? 0;
  }

  Future<void> saveCycleCount(int cycleCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cycleCount', cycleCount);
  }

  Future<int> loadCycleCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('cycleCount') ?? 0;
  }

  // 로그 저장
  Future<void> saveLog(String log) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> logs = prefs.getStringList('logs') ?? [];
    logs.add(log);
    await prefs.setStringList('logs', logs);
  }

  // 로그 불러오기
  Future<List<String>> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('logs') ?? [];
  }
}
