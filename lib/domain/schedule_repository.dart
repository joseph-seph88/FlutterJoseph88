import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/model/schedule.dart';

abstract class ScheduleRepository {
  Future<String> addSchedule(String content, Timestamp makeTime);

  Future<List<Schedule>> getSchedule(DateTime focusedDay);

  Future<List<Schedule>> getSelectSchedule(DateTime selectDay);

  Future<List<Schedule>> getAllSchedule();

  Future<void> updateScheduleStatus(
      String? id, bool isProgress, Timestamp finishTime);
}