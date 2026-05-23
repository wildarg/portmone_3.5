import 'account.dart';
import 'money.dart';
import 'operation_type.dart';
import 'transaction.dart';

class Expense extends Transaction {
  final TransactionType type;
  final Account account;
  final Money amount;

  const Expense({
    required super.uid,
    required super.date,
    required super.timestamp,
    required super.isPending,
    required super.notes,
    required this.type,
    required this.account,
    required this.amount,
  });
}
