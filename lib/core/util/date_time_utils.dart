class DateTimeUtils {
  static const MILLIS_PER_SECOND = 1000;
  static const MILLIS_PER_MINUTE = MILLIS_PER_SECOND * 60;
  static const MILLIS_PER_HOUR = MILLIS_PER_MINUTE * 60;
  static const MILLIS_PER_DAY = MILLIS_PER_HOUR * 24;

  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime theDayBefore(int num) {
    return DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch - MILLIS_PER_DAY * num);
  }

  static DateTime _toBeginOfDay(DateTime input) {
    return DateTime(input.year, input.month, input.day);
  }

  static bool isToday(DateTime input) {
    return _today == _toBeginOfDay(input);
  }

  static bool isAfterFromNow(
    DateTime input, {
    int year = 0,
    int month = 0,
    int day = 0,
    int hour = 0,
  }) {
    final today = DateTime.now();
    final target = DateTime(
      _today.year - year,
      today.month - month,
      today.day - day,
      today.hour - hour,
      today.minute,
      today.second,
    );
    return target.millisecondsSinceEpoch < input.millisecondsSinceEpoch;
  }
}
