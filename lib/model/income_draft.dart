import 'package:portmone_bloc/model/income.dart';

class IncomeDraft {
  final String? uid;
  final DateTime? date;
  final DateTime? timestamp;
  final bool? isPending;
  final String? notes;
  final String? typeName;
  final String? accountName;
  final String? currencyName;
  final int? amountInCents;

  IncomeDraft({
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

  static IncomeDraft fromIncome(Income src) {
    return IncomeDraft(
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

  IncomeDraft copyWith({
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
    return IncomeDraft(
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
