enum RepeatFrequency {
  none, 
  daily,       
  weekday,     
  weekend,    
  weekly,      
  biweekly,    
  monthly,     
  every3Months,
  every6Months,
  yearly       
}

extension RepeatFrequencyExtension on RepeatFrequency {
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

  int get index => this.index;

  static RepeatFrequency fromIndex(int index) {
    return RepeatFrequency.values[index];
  }
}
