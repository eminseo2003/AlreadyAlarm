enum RepeatFrequency {
  none,        // 안 함
  daily,       // 매일
  weekday,     // 평일
  weekend,     // 주말
  weekly,      // 매주
  biweekly,    // 격주
  monthly,     // 매월
  every3Months,// 3개월마다
  every6Months,// 6개월마다
  yearly       // 매년
}

extension RepeatFrequencyExtension on RepeatFrequency {
  // 🔹 한글 문자열 반환 (Swift에서 `case`별 String 값을 지정한 것과 동일한 기능)
  String get title {
    switch (this) {
      case RepeatFrequency.none:
        return "안 함";
      case RepeatFrequency.daily:
        return "매일";
      case RepeatFrequency.weekday:
        return "평일";
      case RepeatFrequency.weekend:
        return "주말";
      case RepeatFrequency.weekly:
        return "매주";
      case RepeatFrequency.biweekly:
        return "격주";
      case RepeatFrequency.monthly:
        return "매월";
      case RepeatFrequency.every3Months:
        return "3개월마다";
      case RepeatFrequency.every6Months:
        return "6개월마다";
      case RepeatFrequency.yearly:
        return "매년";
    }
  }

  // 🔄 Firestore에 저장할 때 Enum을 숫자로 변환 (Index 저장)
  int get index => this.index;

  // 🔄 Firestore에서 불러올 때 숫자를 Enum으로 변환
  static RepeatFrequency fromIndex(int index) {
    return RepeatFrequency.values[index];
  }
}
