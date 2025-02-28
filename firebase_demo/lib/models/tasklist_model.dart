enum TaskList {
  today,       
  future,      
  full,       
  complete    
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
