import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/money.dart';

sealed class AmountTracker {
  final Money amount;
  AmountTracker(this.amount);

  @override
  String toString() {
    return '{amount: $amount}';
  }
}

class TodayAmountTracker extends AmountTracker {
  TodayAmountTracker(super.amount);
}

class LabeledAmountTracker extends AmountTracker {
  final String label;
  LabeledAmountTracker(super.amount, {required this.label});
}

class MonthAmountTracker extends AmountTracker {
  final String monthName;
  MonthAmountTracker(super.amount, this.monthName);

  @override
  String toString() {
    return '{amount: $amount, monthName: $monthName}';
  }
}

class DateAmountTracker extends AmountTracker {
  final DateTime date;
  DateAmountTracker(this.date, super.amount);
}

class AmountTrackerData {
  final Currency currency;
  final AmountTracker first;
  final AmountTracker second;

  AmountTrackerData({
    required this.currency,
    required this.first,
    required this.second,
  });

  @override
  String toString() {
    return '{currency: $currency, first: $first, second: $second}';
  }
}
