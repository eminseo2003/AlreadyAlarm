import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/models/alarm_model.dart';
import 'dart:developer';

class AlarmService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 알람 추가 (Firestore에 데이터 저장)
  Future<void> addAlarm(AlarmModel alarm) async {
  try {
    await _db.collection('alarms').doc(alarm.id).set(alarm.toJson());

    if (alarm.userListId.isNotEmpty == true) {
      final userListRef = _db.collection('userlists').doc(alarm.userListId);
      final userListDoc = await userListRef.get();

      if (userListDoc.exists) {
        await userListRef.update({
          'alarms': FieldValue.arrayUnion([alarm.id]),
        });
      } else {
        log('Firestore 문서 없음: ${alarm.userListId}');
      }
    }
  } catch (e) {
    log('addAlarm 실패: $e');
  }
}

  Stream<List<AlarmModel>> getAlarms() {
    
    try {

      return FirebaseFirestore.instance
          .collection('alarms')
          .snapshots()
          .map((snapshot) {

            return snapshot.docs.map((doc) {
              return AlarmModel.fromFirestore(doc);
            }).toList();
          });
    } catch (e) {
      return const Stream.empty();
    }
  }


  // 특정 알람 가져오기
  Future<AlarmModel?> getAlarmById(String id) async {
    DocumentSnapshot doc = await _db.collection('alarms').doc(id).get();
    if (doc.exists) {
      return AlarmModel.fromFirestore(doc);
    }
    return null;
  }

  // 알람 삭제
  Future<void> deleteAlarm(String id) async {
    await _db.collection('alarms').doc(id).delete();
  }

  // 알람 업데이트
  Future<void> updateAlarm(AlarmModel alarm) async {
    await _db.collection('alarms').doc(alarm.id).update(alarm.toJson());
  }

  Future<void> updateAlarmStatus(String alarmId, bool isCompleted) async {
    await _db.collection('alarms').doc(alarmId).update({
      'isCompleted': isCompleted, // 특정 필드만 업데이트
    });
  }

  Stream<List<AlarmModel>> getTodayAlarms() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day); 

    return _db
        .collection('alarms')
        .where('date', isEqualTo: Timestamp.fromDate(today))
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AlarmModel.fromFirestore(doc)).toList());
  }
  Stream<List<AlarmModel>> getScheduledAlarms() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day); 

    return _db
        .collection('alarms')
        .where('date', isGreaterThan: Timestamp.fromDate(today))
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AlarmModel.fromFirestore(doc)).toList());
  }
  Stream<List<AlarmModel>> getAllAlarms() {
    return _db
        .collection('alarms')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AlarmModel.fromFirestore(doc)).toList());
  }
  Stream<List<AlarmModel>> getCompletedAlarms() {
    return _db
        .collection('alarms')
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AlarmModel.fromFirestore(doc)).toList());
  }
  Future<int> getTodayAlarmCount() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day); 

    QuerySnapshot snapshot = await _db
        .collection('alarms')
        .where('date', isEqualTo: Timestamp.fromDate(today))
        .get();

    return snapshot.size;
  }

  Future<int> getScheduledAlarmCount() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day); 

    QuerySnapshot snapshot = await _db
        .collection('alarms')
        .where('date', isGreaterThan: Timestamp.fromDate(today))
        .get();

    return snapshot.size;
  }

  Future<int> getAllAlarmCount() async {
    QuerySnapshot snapshot = await _db
        .collection('alarms')
        .get();

    return snapshot.size;
  }

  Future<int> getCompletedAlarmCount() async {
    QuerySnapshot snapshot = await _db
        .collection('alarms')
        .where('isCompleted', isEqualTo: true)
        .get();

    return snapshot.size;
  }
}
