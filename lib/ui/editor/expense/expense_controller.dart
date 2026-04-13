import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/model/expense_draft.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';
import 'package:portmone_bloc/utils/money_text_controller.dart';

class ExpenseController {

  final Expense? expense;

  ExpenseDraft _draft;
  final TextEditingController typeController;
  final TextEditingController accountController;
  final TextEditingController currencyController;
  final TextEditingController notesController;
  final MoneyFormatTextEditingController amountController;

  ExpenseController(this.expense) 
    : _draft = expense?.let(ExpenseDraft.fromExpense) 
        ?? ExpenseDraft(date: DateTime.now()),
      typeController = TextEditingController(text: expense?.type.name ?? ''),
      accountController = TextEditingController(text: expense?.account.name ?? ''),
      currencyController = TextEditingController(text: expense?.account.currency.name ?? ''),
      notesController = TextEditingController(text: expense?.notes ?? ''),
      amountController = MoneyFormatTextEditingController(cents: expense?.amount.amountInCents);

  DateTime? get date => _draft.date;
  bool get isPending => _draft.isPending ?? false;

  void setDate(DateTime? date) {
    _draft = _draft.copyWith(date: date);
  }

  void setPending(bool isPending) {
    _draft = _draft.copyWith(isPending: isPending);
  }

  String? get errorMessage {
    if (date == null) return 'Select expense date';
    if (typeController.text.isEmpty) return 'The expense type is empty';
    if (accountController.text.isEmpty) return 'The account name is empty';
    if (currencyController.text.isEmpty) return 'The currency name is empty';
    if (amountController.amount <= 0) return 'The amount is zero';
    return null;
  }

  ExpenseDraft get draft {
    return ExpenseDraft(
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