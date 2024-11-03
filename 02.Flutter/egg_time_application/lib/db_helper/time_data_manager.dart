import 'package:shared_preferences/shared_preferences.dart';

class TimeDataManager {
  // 누적 공부 시간 저장
  Future<void> saveAccumulatedTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accumulatedStudySeconds', time);
  }

  // 누적 공부 시간 불러오기
  Future<int> loadAccumulatedTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('accumulatedStudySeconds') ?? 0;
  }

  // 오늘의 공부 시간 저장
  Future<void> saveTodayTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('todayStudySeconds', time);
  }

  // 오늘의 공부 시간 불러오기
  Future<int> loadTodayTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('todayStudySeconds') ?? 0;
  }

  // 사이클 횟수 저장
  Future<void> saveCycleCount(int cycleCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cycleCount', cycleCount);
  }

  // 사이클 횟수 불러오기
  Future<int> loadCycleCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('cycleCount') ?? 0;
  }
}
