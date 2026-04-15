import 'package:portmone_bloc/model/transfer.dart';

class TransferDraft {
  final String? uid;
  final DateTime? date;
  final DateTime? timestamp;
  final bool? isPending;
  final String? notes;
  final String? fromAccountName;
  final String? fromCurrencyName;
  final int? fromAmountInCents;
  final String? toAccountName;
  final String? toCurrencyName;
  final int? toAmountInCents;

  TransferDraft({
    this.uid,
    this.date,
    this.timestamp,
    this.isPending,
    this.notes,
    this.fromAccountName,
    this.fromCurrencyName,
    this.fromAmountInCents,
    this.toAccountName,
    this.toCurrencyName,
    this.toAmountInCents,
  });

  static TransferDraft fromTransfer(Transfer src) {
    return TransferDraft(
      uid: src.uid,
      date: src.date,
      timestamp: src.timestamp,
      isPending: src.isPending,
      fromAccountName: src.fromAccount.name,
      fromCurrencyName: src.fromAccount.currency.name,
      fromAmountInCents: src.fromAmount.amountInCents,
      toAccountName: src.toAccount.name,
      toCurrencyName: src.toAccount.currency.name,
      toAmountInCents: src.toAmount.amountInCents,
      notes: src.notes,
    );
  }

  TransferDraft copyWith({
    String? uid,
    DateTime? date,
    DateTime? timestamp,
    bool? isPending,
    String? notes,
    String? fromAccountName,
    String? fromCurrencyName,
    int? fromAmountInCents,
    String? toAccountName,
    String? toCurrencyName,
    int? toAmountInCents,
  }) {
    return TransferDraft(
      uid: uid ?? this.uid,
      date: date ?? this.date,
      timestamp: timestamp ?? this.timestamp,
      isPending: isPending ?? this.isPending,
      notes: notes ?? this.notes,
      fromAccountName: fromAccountName ?? this.fromAccountName,
      fromCurrencyName: fromCurrencyName ?? this.fromCurrencyName,
      fromAmountInCents: fromAmountInCents ?? this.fromAmountInCents,
      toAccountName: toAccountName ?? this.toAccountName,
      toCurrencyName: toCurrencyName ?? this.toCurrencyName,
      toAmountInCents: toAmountInCents ?? this.toAmountInCents,
    );
  }
}
