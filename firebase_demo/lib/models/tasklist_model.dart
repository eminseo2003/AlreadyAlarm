enum TaskList {
  today,       // 오늘 할 일
  future,      // 예정된 할 일
  full,        // 전체 목록
  complete     // 완료된 할 일
}

extension TaskListExtension on TaskList {
  String get title {
    switch (this) {
      case TaskList.today:
        return "오늘";
      case TaskList.future:
        return "예정";
      case TaskList.full:
        return "전체";
      case TaskList.complete:
        return "완료됨";
    }
  }
}
