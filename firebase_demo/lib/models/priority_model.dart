enum Priority {
  none,
  low,
  medium,
  high
}

extension PriorityExtension on Priority {
  // 🔹 한글 문자열 반환 (Swift에서 `case`별 String 값을 지정한 것과 동일한 기능)
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

  // 🔄 Firestore에 저장할 때 Enum을 숫자로 변환 (Index 저장)
  int get index => this.index;

  // 🔄 Firestore에서 불러올 때 숫자를 Enum으로 변환
  static Priority fromIndex(int index) {
    return Priority.values[index];
  }
}
