import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/money.dart';

class Budget {
  final String uid;
  final String name;
  final Money amount;
  final Currency currency;
  final List<String> expenseTypeUids;

  Budget({
    required this.uid,
    this.name = '',
    this.amount = const Money(amountInCents: 0),
    Currency? currency,
    this.expenseTypeUids = const <String>[],
  }) : currency = currency ?? Currency(uid: '', name: '');

  Budget copy({
    String? name,
    Money? amount,
    Currency? currency,
    List<String>? expenseTypeUids,
  }) {
    return Budget(
      uid: uid,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      expenseTypeUids: expenseTypeUids ?? this.expenseTypeUids,
    );
  }

  @override
  String toString() =>
      '{name: $name, amount: $amount, currency: $currency, expenseTypeUids: $expenseTypeUids}';
}
