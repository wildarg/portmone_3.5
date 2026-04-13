import 'account.dart';
import 'money.dart';
import 'transaction.dart';

class Transfer extends Transaction {
  final Account fromAccount;
  final Money fromAmount;
  final Account toAccount;
  final Money toAmount;

  const Transfer({
    required super.uid,
    required super.date,
    required super.timestamp,
    required super.isPending,
    required super.notes,
    required this.fromAccount,
    required this.fromAmount,
    required this.toAccount,
    required this.toAmount,
  });
}
