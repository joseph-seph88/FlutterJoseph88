import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/firebase_data_source.dart';
import '../data/schedule.dart';

abstract class ScheduleRepository {
  Future<String> addSchedule(String content, Timestamp makeTime);

  Future<List<Schedule>> getSchedule(DateTime focusedDay);

  Future<List<Schedule>> getSelectSchedule(DateTime selectDay);

  Future<List<Schedule>> getAllSchedule();

  Future<void> updateScheduleStatus(
      String? id, bool isProgress, Timestamp finishTime);
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final FirebaseDataSource _firebaseDataSource;

  ScheduleRepositoryImpl(this._firebaseDataSource);

  @override
  Future<String> addSchedule(String content, Timestamp makeTime) async {
    try {
      final scheduleData = Schedule(content: content, makeTime: makeTime);
      final id = await _firebaseDataSource.addSchedule(scheduleData);
      await _firebaseDataSource.updateSchedule(id);
      return id;
    } catch (e) {
      Exception('[REPO] addSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Schedule>> getSchedule(DateTime focusedDay) async {
    try {
      final startDay = DateTime(focusedDay.year, focusedDay.month, 1);
      final endDay = DateTime(focusedDay.year, focusedDay.month, 31);

      final scheduleList =
          await _firebaseDataSource.getSchedule(startDay, endDay);

      if (scheduleList.isEmpty) {
        Exception('[REPO] getSchedule null error');
      }
      return scheduleList;
    } catch (e) {
      Exception('[REPO] getSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Schedule>> getAllSchedule() async {
    try {
      final scheduleList = await _firebaseDataSource.getAllSchedule();

      if (scheduleList.isEmpty) {
        Exception('[REPO] getSchedule null error');
      }
      return scheduleList;
    } catch (e) {
      Exception('[REPO] getAllSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Schedule>> getSelectSchedule(DateTime selectDay) async {
    try {
      DateTime selectTime =
          DateTime(selectDay.year, selectDay.month, selectDay.day);

      final scheduleList =
          await _firebaseDataSource.getSelectSchedule(selectTime);

      if (scheduleList.isEmpty) {
        Exception('[REPO] getSelectSchedule null error');
      }
      return scheduleList;
    } catch (e) {
      Exception('[REPO] getSelectSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> updateScheduleStatus(
      String? id, bool isProgress, Timestamp finishTime) async {
    try {
      if (id == null) {
        Exception('[REPO] updateScheduleStatus null error');
      }
      await _firebaseDataSource.updateScheduleStatus(
          id!, isProgress, finishTime);
    } catch (e) {
      Exception('[REPO] updateSchedule Error ${e.toString()}');
      rethrow;
    }
  }
}
