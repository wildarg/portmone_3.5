import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/model/transfer_draft.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';
import 'package:portmone_bloc/utils/money_text_controller.dart';

class TransferController {
  final Transfer? transfer;

  TransferDraft _draft;
  final TextEditingController fromAccountController;
  final TextEditingController fromCurrencyController;
  final MoneyFormatTextEditingController fromAmountController;

  final TextEditingController toAccountController;
  final TextEditingController toCurrencyController;
  final MoneyFormatTextEditingController toAmountController;

  final TextEditingController notesController;

  TransferController(this.transfer)
      : _draft = transfer?.let(TransferDraft.fromTransfer) ?? TransferDraft(date: DateTime.now()),
        fromAccountController = TextEditingController(text: transfer?.fromAccount.name ?? ''),
        fromCurrencyController = TextEditingController(text: transfer?.fromAccount.currency.name ?? ''),
        fromAmountController = MoneyFormatTextEditingController(cents: transfer?.fromAmount.amountInCents),
        toAccountController = TextEditingController(text: transfer?.toAccount.name ?? ''),
        toCurrencyController = TextEditingController(text: transfer?.toAccount.currency.name ?? ''),
        toAmountController = MoneyFormatTextEditingController(cents: transfer?.toAmount.amountInCents),
        notesController = TextEditingController(text: transfer?.notes ?? '');

  DateTime? get date => _draft.date;
  bool get isPending => _draft.isPending ?? false;

  void setDate(DateTime? date) {
    _draft = _draft.copyWith(date: date);
  }

  void setPending(bool isPending) {
    _draft = _draft.copyWith(isPending: isPending);
  }

  String? get errorMessage {
    if (date == null) return 'Select transfer date';
    if (fromAccountController.text.isEmpty) return 'The source account is empty';
    if (fromCurrencyController.text.isEmpty) return 'The source currency is empty';
    if (fromAmountController.amount <= 0) return 'The source amount is zero';
    if (toAccountController.text.isEmpty) return 'The destination account is empty';
    if (toCurrencyController.text.isEmpty) return 'The destination currency is empty';
    if (toAmountController.amount <= 0) return 'The destination amount is zero';
    return null;
  }

  TransferDraft get draft {
    return TransferDraft(
      uid: _draft.uid,
      date: _draft.date,
      timestamp: _draft.timestamp,
      isPending: _draft.isPending,
      notes: notesController.text,
      fromAccountName: fromAccountController.text,
      fromCurrencyName: fromCurrencyController.text,
      fromAmountInCents: fromAmountController.amount,
      toAccountName: toAccountController.text,
      toCurrencyName: toCurrencyController.text,
      toAmountInCents: toAmountController.amount,
    );
  }

  void dispose() {
    fromAccountController.dispose();
    fromCurrencyController.dispose();
    fromAmountController.dispose();
    toAccountController.dispose();
    toCurrencyController.dispose();
    toAmountController.dispose();
    notesController.dispose();
  }
}
