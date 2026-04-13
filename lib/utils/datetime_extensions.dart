import 'package:intl/intl.dart';

extension DatetimeExtensions on DateTime {

  String get fullFormat {
    return DateFormat("dd MMM yyyy").format(this);
  }

  String get shortFormat {
    return DateFormat("dd MMM").format(this);
  }

  DateTime get addDay => add(const Duration(days: 1));
  DateTime get minusDay => add(const Duration(days: -1));

  DateTime addDays(int days) => add(Duration(days: days));


  DateTime get firstDayOfMonth {
    return DateTime(
      year,
      month,
      1      
    );
  }

  DateTime get startDay {
    return DateTime(
      year,
      month,
      day      
    );
  }

  DateTime get endDay {
    return DateTime(
      year,
      month,
      day,
      23,
      59,
      59
    );
  }

  DateTime get lastDayOfMonth {
    return DateTime(
      month < 12? year : year + 1,
      month < 12? month + 1 : 1,
      1
    ).minusDay;
  }

  DateTime get monthBack {
    return DateTime(
      month > 1? year : year - 1,
      month > 1? month - 1 : 12,
      day
    );
  }

  DateTime get monthForward {
    return DateTime(
      month < 12? year : year + 1,
      month < 12? month + 1 : 1,
      day
    );
  }

  String shortMonthName([String? locale]) {
    return DateFormat('MMM', locale).format(this);
  }

  DateTime get withoutTime {
    return DateTime(year, month, day);
  }



}
