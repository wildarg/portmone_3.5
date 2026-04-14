import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/model/income_draft.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';
import 'package:portmone_bloc/utils/money_text_controller.dart';

class IncomeController {

  final Income? income;

  IncomeDraft _draft;
  final TextEditingController typeController;
  final TextEditingController accountController;
  final TextEditingController currencyController;
  final TextEditingController notesController;
  final MoneyFormatTextEditingController amountController;

  IncomeController(this.income) 
    : _draft = income?.let(IncomeDraft.fromIncome) 
        ?? IncomeDraft(date: DateTime.now()),
      typeController = TextEditingController(text: income?.type.name ?? ''),
      accountController = TextEditingController(text: income?.account.name ?? ''),
      currencyController = TextEditingController(text: income?.account.currency.name ?? ''),
      notesController = TextEditingController(text: income?.notes ?? ''),
      amountController = MoneyFormatTextEditingController(cents: income?.amount.amountInCents);

  DateTime? get date => _draft.date;
  bool get isPending => _draft.isPending ?? false;

  void setDate(DateTime? date) {
    _draft = _draft.copyWith(date: date);
  }

  void setPending(bool isPending) {
    _draft = _draft.copyWith(isPending: isPending);
  }

  String? get errorMessage {
    if (date == null) return 'Select income date';
    if (typeController.text.isEmpty) return 'The income type is empty';
    if (accountController.text.isEmpty) return 'The account name is empty';
    if (currencyController.text.isEmpty) return 'The currency name is empty';
    if (amountController.amount <= 0) return 'The amount is zero';
    return null;
  }

  IncomeDraft get draft {
    return IncomeDraft(
      uid: _draft.uid,
      date: _draft.date,
      timestamp: _draft.timestamp,
      isPending: _draft.isPending,
      notes: notesController.text,
      typeName: typeController.text,
      accountName: accountController.text,
      currencyName: currencyController.text,
      amountInCents: amountController.amount,
    );
  }

  void dispose() {
    typeController.dispose();
    accountController.dispose();
    currencyController.dispose();
    amountController.dispose();
    notesController.dispose();
  }

}
