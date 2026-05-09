import 'dart:math';

import 'package:intl/intl.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';

class DateTimeUtils {

  static DateTime? toDateTime(int? ms) => ms != null? DateTime.fromMillisecondsSinceEpoch(ms) : null;

  static String? toFilterDate(DateTime? dt, String? locale) {
    if (dt == null) return null;
    return DateFormat("dd MMM yyyy", locale).format(dt);
  }

  static String? toChartLabel(DateTime? dt, String? locale,{ bool showMonth = true}) {
    if (dt == null) return null;
    String pattern = showMonth? "dd MMM" : "dd";
    return DateFormat(pattern, locale).format(dt);
  }

  static DateTime parse(String text) {
    String pattern = 'yyyy-MM-dd';
    return DateFormat(pattern).parse(text);
  }

  static String shortMonthName(DateTime dt, [String? locale]) {
    return DateFormat('MMM', locale).format(dt);
  }

  static String? monthDate(DateTime? dt, String? locale) {
    if (dt == null) return null;
    return DateFormat("MMM", locale).format(dt);
  }

  static DateTime removeTime(DateTime src) {
    return DateTime(src.year, src.month, src.day);
  }

  static DateTime today() {
    return DateTime.now().let(removeTime);
  }

  static DateTime now() {
    return DateTime.now();
  }

  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      1      
    );
  }

  static DateTime startDay(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day      
    );
  }

  static DateTime endDay(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59
    );
  }

  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(
      date.month < 12? date.year : date.year + 1,
      date.month < 12? date.month + 1 : 1,
      1
    ).add(const Duration(days: -1));    
  }

  static DateTime monthBack(DateTime date) {
    return DateTime(
      date.month > 1? date.year : date.year - 1,
      date.month > 1? date.month - 1 : 12,
      date.day
    );
  }

  static DateTime monthForward(DateTime date) {
    return DateTime(
      date.month < 12? date.year : date.year + 1,
      date.month < 12? date.month + 1 : 1,
      date.day
    );
  }

  static (DateTime, DateTime) getCurrentInterval(DateTime? startDate, DateTime? endDate) {
    DateTime now = DateTime.now();
    if (startDate == null && endDate == null) {
      return (firstDayOfMonth(now), lastDayOfMonth(now));
    }
    if (startDate == null) {
      return (
        endDate!.monthBack.addDay,
        endDate
      );
    }
    if (endDate == null) {
      return (
        startDate,
        startDate.monthForward.minusDay
      );
    }
    return (startDate, endDate);
  }

  static (DateTime, DateTime) getBudgetInterval(DateTime? startDate, DateTime? endDate) {
    DateTime _now = DateTime.now();
    DateTime now = DateTime(2025, _now.month, _now.day);
    if (startDate == null) {
      return (firstDayOfMonth(now), lastDayOfMonth(now));
    }

    if (now.day >= startDate.day) {
      return (
        DateTime(
          now.year,
          now.month,
          startDate.day
        ),
        DateTime(
          now.year,
          now.month,
          startDate.day
        ).monthForward.minusDay        
      );
    } else {
      final prevMonth = now.monthBack;
      final day = min(lastDayOfMonth(prevMonth).day, startDate.day);
      return (
        DateTime(
          prevMonth.year,
          prevMonth.month,
          day
        ),
        DateTime(
          prevMonth.year,
          prevMonth.month,
          day
        ).monthForward.minusDay,
      );
    }
  }

  static Iterable<DateTime> iterate(DateTime startDate, DateTime endDate) {
    return Iterable.generate(
      endDate.difference(startDate).inDays + 1, 
      (int days) => startDate.add(Duration(days: days))
    );
  }

}