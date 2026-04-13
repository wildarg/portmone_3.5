import 'package:portmone_bloc/model/money.dart';

class MoneyDateInfo {
  final DateTime date;
  final Money amount;
  MoneyDateInfo(this.date, this.amount);

  @override
  String toString() {
    return '{date: $date, amount: $amount}';
  }
}