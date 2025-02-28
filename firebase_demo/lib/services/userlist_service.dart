import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/models/userlist_model.dart';
import 'package:firebase_demo/models/alarm_model.dart';
import 'dart:developer';

class UserlistService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 사용자 리스트 추가 (Firestore에 데이터 저장)
  Future<void> addUserList(UserListModel userList) async {
    await _db.collection('userlists').doc(userList.id).set(userList.toJson());
  }
  // 모든 유저 리스트 가져오기
  Stream<List<UserListModel>> getUserLists() {
    return _db.collection('userlists').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserListModel.fromFirestore(doc)).toList());
  }

  // 특정 유저 리스트 가져오기
  Future<UserListModel?> getUserListById(String id) async {
    DocumentSnapshot doc = await _db.collection('userlists').doc(id).get();
    if (doc.exists) {
      return UserListModel.fromFirestore(doc);
    }
    return null;
  }

  // 유저 리스트 삭제 (해당 리스트의 모든 알람도 삭제)
  Future<void> deleteUserList(String userListId) async {
    // 1. 해당 UserList에 속한 모든 알람 삭제
    QuerySnapshot alarmSnapshot = await _db
        .collection('alarms')
        .where('userListId', isEqualTo: userListId)
        .get();

    for (var doc in alarmSnapshot.docs) {
      await doc.reference.delete();
    }

    // 2. 유저 리스트 삭제
    await _db.collection('userlists').doc(userListId).delete();
  }

  // 유저 리스트 업데이트
  Future<void> updateUserList(UserListModel userList) async {
    final docRef = FirebaseFirestore.instance.collection('userlists').doc(userList.id);

    // 🔹 문서 존재 여부 확인
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      throw Exception("🔥 오류: 해당 userList 문서가 Firestore에 존재하지 않습니다! ID: ${userList.id}");
    }

    await docRef.update(userList.toJson());
  }


  // 특정 유저 리스트의 모든 알람 가져오기
  Stream<List<AlarmModel>> getAlarmsForUserList(String userListId) {
    return _db
        .collection('alarms')
        .where('userListId', isEqualTo: userListId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AlarmModel.fromFirestore(doc)).toList());
  }
  Future<void> updateSortOption(String userListId, String newSortOption) async {
    final docRef = FirebaseFirestore.instance.collection('userlists').doc(userListId);

    await docRef.update({
      'sortOption': newSortOption,
    }).then((_) {
      log("✅ Firestore 데이터 업데이트 성공!");
    }).catchError((error) {
      log("❌ Firestore 데이터 업데이트 실패: $error");
    });
  }
}
