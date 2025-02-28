enum Priority {
  none,
  low,
  medium,
  high
}

extension PriorityExtension on Priority {
  String get title {
    switch (this) {
      case Priority.none:
        return "없음";
      case Priority.low:
        return "낮음";
      case Priority.medium:
        return "중간";
      case Priority.high:
        return "높음";
    }
  }

  int get index => this.index;

  static Priority fromIndex(int index) {
    return Priority.values[index];
  }
}
