import 'package:portmone_bloc/model/transaction.dart';

class DateTransactions {
  final DateTime dateTime;
  final List<Transaction> transactions;
  DateTransactions({required this.dateTime, required this.transactions});
}
