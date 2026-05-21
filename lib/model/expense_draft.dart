import 'package:portmone_bloc/model/expense.dart';

class ExpenseDraft {
  final String? uid;
  final DateTime? date;
  final DateTime? timestamp;
  final bool? isPending;
  final String? notes;
  final String? typeName;
  final String? accountName;
  final String? currencyName;
  final int? amountInCents;

  ExpenseDraft({
    this.uid,
    this.date,
    this.timestamp,
    this.isPending,
    this.notes,
    this.typeName,
    this.accountName,
    this.currencyName,
    this.amountInCents,
  });

  static ExpenseDraft fromExpense(Expense src) {
    return ExpenseDraft(
      uid: src.uid,
      date: src.date,
      timestamp: src.timestamp,
      isPending: src.isPending,
      typeName: src.type.name,
      accountName: src.account.name,
      currencyName: src.account.currency.name,
      amountInCents: src.amount.amountInCents,
      notes: src.notes,
    );
  }

  ExpenseDraft copyWith({
    String? uid,
    DateTime? date,
    DateTime? timestamp,
    bool? isPending,
    String? notes,
    String? typeName,
    String? accountName,
    String? currencyName,
    int? amountInCents,
  }) {
    return ExpenseDraft(
      uid: uid ?? this.uid,
      date: date ?? this.date,
      timestamp: timestamp ?? this.timestamp,
      isPending: isPending ?? this.isPending,
      notes: notes ?? this.notes,
      typeName: typeName ?? this.typeName,
      accountName: accountName ?? this.accountName,
      currencyName: currencyName ?? this.currencyName,
      amountInCents: amountInCents ?? this.amountInCents,
    );
  }
}
