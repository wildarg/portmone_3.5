import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/model/operation_type.dart';

class ExpenseRecordInfo {
  final DateTime date;
  final TransactionType type;
  final Currency currency;
  final Money amount;

  ExpenseRecordInfo({required this.date, required this.type, required this.currency, required this.amount});
}