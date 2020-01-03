import 'package:conversation_maker/core/util/date_time_utils.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("is after from now", () {
    DateTime now = DateTime.now();
    expect(true, DateTimeUtils.isAfterFromNow(now, hour: 1));
    expect(true, DateTimeUtils.isToday(now));
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    expect(false, DateTimeUtils.isAfterFromNow(yesterday, hour: 1));
  });
}
