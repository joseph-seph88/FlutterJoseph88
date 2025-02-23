import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_project/data/schedule_repository.dart';
import '../data/schedule.dart';

abstract class ScheduleUseCase {
  Future<String> addSchedule(String content, Timestamp makeTime);

  Future<List<Schedule>> getSchedule(DateTime focusedDay);

  Future<List<Schedule>> getAllSchedule();

  Future<List<Schedule>> getSelectSchedule(DateTime selectDay);

    Future<void> updateScheduleStatus(String? id, bool isProgress, Timestamp finishTime);
  }

class ScheduleUseCaseImpl implements ScheduleUseCase {
  final ScheduleRepository _repository;

  ScheduleUseCaseImpl(this._repository);

  @override
  Future<String> addSchedule(String content, Timestamp makeTime) async {
    try {
      final id = await _repository.addSchedule(content, makeTime);
      return id;
    } catch (e) {
      Exception('[USE] addSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Schedule>> getSchedule(DateTime focusedDay) async {
    try {
      final scheduleList = await _repository.getSchedule(focusedDay);

      if (scheduleList.isEmpty) {
        Exception('[USE] getSchedule null error');
      }
      return scheduleList;
    } catch (e) {
      Exception('[USE] getSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Schedule>> getAllSchedule() async {
    try {
      final scheduleList = await _repository.getAllSchedule();

      if (scheduleList.isEmpty) {
        Exception('[USE] getAllSchedule null error');
      }
      return scheduleList;
    } catch (e) {
      Exception('[USE] getAllSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Schedule>> getSelectSchedule(DateTime selectDay) async {
    try {
      final scheduleList = await _repository.getSelectSchedule(selectDay);

      if (scheduleList.isEmpty) {
        Exception('[USE] getSelectSchedule null error');
      }
      return scheduleList;
    } catch (e) {
      Exception('[USE] getSelectSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> updateScheduleStatus(String? id, bool isProgress, Timestamp finishTime) async{
    try{
      await _repository.updateScheduleStatus(id, isProgress, finishTime);
    }catch (e) {
      Exception('[USE] updateSchedule Error ${e.toString()}');
      rethrow;
    }
  }

}
