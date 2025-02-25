import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/model/schedule.dart';
import '../../domain/schedule_use_case.dart';

class ScheduleController extends GetxController {
  final ScheduleUseCase _scheduleUseCase = Get.find<ScheduleUseCase>();
  final contentController = TextEditingController();

  var isProgress = true.obs;
  var isSummary = false.obs;

  var totalSchedule = <Schedule>[].obs;
  var scheduleMonth = <Schedule>[].obs;
  var scheduleToday = <Schedule>[].obs;
  var progressSchedule = <Schedule>[].obs;
  var finishSchedule = <Schedule>[].obs;

  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var calendarFormat = CalendarFormat.month.obs;

  @override
  void onInit() {
    super.onInit();
    getAllSchedule();
  }

  void getAllSchedule() async {
    try {
      totalSchedule.value = await _scheduleUseCase.getAllSchedule();
      getProgressSchedule();
      getFinishedSchedule();
      getSelectSchedule();
      getMonthSchedule();
    } catch (e) {
      throw Exception('[SCTR] getAllSchedule Error ${e.toString()}');
    }
  }

  void getSelectSchedule() {
    scheduleToday.value = totalSchedule.where((value) {
      DateTime makeTime = value.makeTime.toDate();
      return makeTime.year == focusedDay.value.year &&
          makeTime.month == focusedDay.value.month &&
          makeTime.day == focusedDay.value.day;
    }).toList();
  }

  void getMonthSchedule() {
    scheduleMonth.value = totalSchedule.where((value) {
      DateTime makeTime = value.makeTime.toDate();
      return makeTime.year == focusedDay.value.year &&
          makeTime.month == focusedDay.value.month;
    }).toList();
  }

  void getProgressSchedule() {
    progressSchedule.value =
        totalSchedule.where((value) => value.isProgress).toList();
  }

  void getFinishedSchedule() {
    finishSchedule.value =
        totalSchedule.where((value) => !value.isProgress).toList();
  }

  List<Schedule> getEventLoader(DateTime value) {
    return totalSchedule.where((schedule) {
      DateTime makeTime = schedule.makeTime.toDate();
      return makeTime.year == value.year &&
          makeTime.month == value.month &&
          makeTime.day == value.day;
    }).toList();
  }

  void completeSchedule(Schedule schedule) async {
    try {
      final finishTime = Timestamp.fromDate(DateTime.now());
      final newSchedule =
          schedule.copyWith(finishTime: finishTime, isProgress: false);
      progressSchedule.removeWhere((data) => data.id == schedule.id);
      finishSchedule.add(newSchedule);

      int index = totalSchedule.indexWhere((data) => data.id == schedule.id);
      if (index != -1) {
        totalSchedule[index] = totalSchedule[index]
            .copyWith(finishTime: finishTime, isProgress: false);
      }

      await _scheduleUseCase.updateScheduleStatus(
          schedule.id, false, finishTime);
    } catch (e) {
      throw Exception('[SCTR] completeSchedule Error ${e.toString()}');
    }
  }

  void restoreSchedule(Schedule schedule) async {
    try {
      finishSchedule.removeWhere((data) => data.id == schedule.id);
      final newSchedule =
          schedule.copyWith(finishTime: Timestamp(0, 0), isProgress: true);
      progressSchedule.add(newSchedule);

      int index = totalSchedule.indexWhere((data) => data.id == schedule.id);
      if (index != -1) {
        totalSchedule[index] = totalSchedule[index]
            .copyWith(finishTime: Timestamp(0, 0), isProgress: true);
      }

      await _scheduleUseCase.updateScheduleStatus(
          schedule.id, true, Timestamp(0, 0));
    } catch (e) {
      throw Exception('[SCTR] restoreSchedule Error ${e.toString()}');
    }
  }

  void addSchedule() async {
    try {
      final makeTime = Timestamp.fromDate(DateTime.now());
      final id =
          await _scheduleUseCase.addSchedule(contentController.text, makeTime);
      final newSchedule =
          Schedule(id: id, content: contentController.text, makeTime: makeTime);
      progressSchedule.add(newSchedule);
      scheduleMonth.add(newSchedule);
      totalSchedule.add(newSchedule);
      getSelectSchedule();
      contentController.clear();

    } catch (e) {
      throw Exception('[SCTR] addSchedule Error ${e.toString()}');
    }
  }

  bool checkProgress(Schedule schedule) {
    final filteredSchedules = totalSchedule.where((value) {
      return value.id == schedule.id;
    }).toList();

    if (filteredSchedules.isNotEmpty) {
      return filteredSchedules.first.isProgress;
    }
    return true;
  }

  void changeCalendarFormat() {
    calendarFormat.value = calendarFormat.value == CalendarFormat.month
        ? CalendarFormat.week
        : CalendarFormat.month;
  }

  void onOffSummary() {
    isSummary.value = !isSummary.value;
  }

  void onOffProgress() {
    isProgress.value = !isProgress.value;
  }

  String transTimeFormat(Timestamp makeTime) {
    DateTime date = makeTime.toDate();
    return "${date.year}-${date.month}-${date.day}";
  }
}