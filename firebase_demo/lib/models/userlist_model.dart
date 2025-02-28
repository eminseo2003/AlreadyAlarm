import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum SortOption { manual, dueDate, dateCreated, priority, title }

extension SortOptionExtension on SortOption {
  String get key {
    switch (this) {
      case SortOption.manual:
        return "수동";
      case SortOption.dueDate:
        return "마감일";
      case SortOption.dateCreated:
        return "생성일";
      case SortOption.priority:
        return "우선 순위";
      case SortOption.title:
        return "제목";
    }
  }

  // 🔄 Firestore에서 불러올 때 문자열을 Enum으로 변환
  static SortOption fromKey(String key) {
    switch (key) {
      case "수동":
        return SortOption.manual;
      case "마감일":
        return SortOption.dueDate;
      case "생성일":
        return SortOption.dateCreated;
      case "우선 순위":
        return SortOption.priority;
      case "제목":
        return SortOption.title;
      default:
        return SortOption.manual; // 기본값
    }
  }
}

class UserListModel {
  String id;
  String name;
  String color;
  List<String>? alarms; // TodoItem ID 리스트로 Firestore에 저장
  SortOption sortOption;

  UserListModel({
    String? id,
    required this.name,
    this.color = "blue",
    this.alarms,
    this.sortOption = SortOption.manual,
  }) : id = id ?? FirebaseFirestore.instance.collection('userlists').doc().id;

  // 🔹 Firestore에서 가져온 `color` 값을 `Color`로 변환
  Color get colorValue => _getColorFromName(color);

  // 🔄 Firestore에서 데이터를 가져올 때 JSON → 객체 변환
  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      id: json['id'],
      name: json['name'] ?? '미리 알림',
      color: json['color'] ?? 'blue',
      alarms: List<String>.from(json['alarms'] ?? []),
      sortOption: SortOptionExtension.fromKey(json['sortOption'] ?? "수동"),
    );
  }

  // 🔄 객체 → JSON 변환 (Firestore에 저장할 때 사용)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'alarms': alarms ?? [],
      'sortOption': sortOption.key,
    };
  }

  // 🔄 Firestore DocumentSnapshot → 객체 변환
  factory UserListModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserListModel.fromJson(data);
  }
  // 🔹 문자열 색상 변환 함수
  static Color _getColorFromName(String colorName) {
    Map<String, Color> colorMap = {
      "red": Colors.red,
      "orange": Colors.orange,
      "yellow": Colors.yellow,
      "green": Colors.green,
      "blue": Colors.blue,
      "purple": Colors.purple,
      "brown": Colors.brown,
    };

    return colorMap[colorName.toLowerCase()] ?? Colors.grey; // 기본값은 `grey`
  }
}
