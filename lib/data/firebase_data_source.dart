import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:web_project/data/schedule.dart';

class FirebaseDataSource extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addSchedule(Schedule schedule) async {
    try {
      final doc = await _firestore.collection('schedule').add(schedule.toMap());
      return doc.id;
    } catch (e) {
      Exception('[FB-DS] addSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  Future<List<Schedule>> getSchedule(DateTime startDay, DateTime endDay) async {
    try {
      final querySnapshot = await _firestore
          .collection('schedule')
          .where('makeTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDay))
          .where('makeTime', isLessThanOrEqualTo: Timestamp.fromDate(endDay))
          .get();

      return querySnapshot.docs.map((doc) {
        return Schedule.fromMap(doc.data());
      }).toList();
    } catch (e) {
      Exception('[FB-DS] getSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  Future<List<Schedule>> getSelectSchedule(DateTime selectDay) async {
    try {
      final querySnapshot = await _firestore
          .collection('schedule')
          .where('makeTime', isEqualTo: Timestamp.fromDate(selectDay))
          .get();

      return querySnapshot.docs.map((doc) {
        return Schedule.fromMap(doc.data());
      }).toList();
    } catch (e) {
      Exception('[FB-DS] getSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  Future<List<Schedule>> getAllSchedule() async {
    try {
      final querySnapshot = await _firestore.collection('schedule').get();

      return querySnapshot.docs.map((doc) {
        return Schedule.fromMap(doc.data());
      }).toList();
    } catch (e) {
      Exception('[FB-DS] getAllSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateSchedule(String id) async {
    try {
      await _firestore.collection('schedule').doc(id).update({'id': id});
    } catch (e) {
      Exception('[FB-DS] updateSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateScheduleStatus(
      String id, bool isProgress, Timestamp finishTime) async {
    try {
      await _firestore
          .collection('schedule')
          .doc(id)
          .update({'isProgress': isProgress, 'finishTime': finishTime});
    } catch (e) {
      Exception('[FB-DS] updateSchedule Error ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleteSchedule(String id) async {
    try {
      await _firestore.collection('schedule').doc(id).delete();
    } catch (e) {
      Exception('[FB-DS] deleteSchedule Error ${e.toString()}');
      rethrow;
    }
  }
}
