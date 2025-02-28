import 'package:cloud_firestore/cloud_firestore.dart';
import 'repeatfrequency_model.dart';
import 'priority_model.dart';

class AlarmModel {
  String id;
  String title;
  String memo;
  bool isCompleted;
  DateTime? date;
  DateTime? time;
  RepeatFrequency repeatFrequency;
  DateTime? repeatEndDate;
  String? location;
  DateTime createdAt;
  Priority priority;
  String userListId;

  AlarmModel({
    String? id,
    required this.title,
    required this.memo,
    this.isCompleted = false,
    this.date,
    this.time,
    this.repeatFrequency = RepeatFrequency.none,
    this.repeatEndDate,
    this.location,
    DateTime? createdAt,
    this.priority = Priority.none,
    required this.userListId,
  }) : id = id ?? FirebaseFirestore.instance.collection('alarms').doc().id,
       createdAt = createdAt ?? DateTime.now();

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'],
      title: json['title'] ?? '',
      memo: json['memo'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      date: json['date'] != null ? (json['date'] as Timestamp).toDate() : null,
      time: json['time'] != null ? (json['time'] as Timestamp).toDate() : null,
      repeatFrequency: RepeatFrequency.values[json['repeatFrequency'] ?? 0],
      repeatEndDate:
          json['repeatEndDate'] != null ? (json['repeatEndDate'] as Timestamp).toDate() : null,
      location: json['location'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      priority: Priority.values[json['priority'] ?? 0],
      userListId: json['userListId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'memo': memo,
      'isCompleted': isCompleted,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'time': time != null ? Timestamp.fromDate(time!) : null,
      'repeatFrequency': repeatFrequency.index,
      'repeatEndDate': repeatEndDate != null ? Timestamp.fromDate(repeatEndDate!) : null,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'priority': priority.index,
      'userListId': userListId,
    };
  }

  factory AlarmModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AlarmModel.fromJson(data);
  }
}
