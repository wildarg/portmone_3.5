import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/budget.dart';
import 'package:portmone_bloc/model/budget_draft.dart';
import 'package:portmone_bloc/model/expense_record_info.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/model/money_date_info.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';
import 'package:portmone_bloc/utils/date_utils.dart';
import 'package:portmone_bloc/utils/money_text_controller.dart';
import 'package:rxdart/rxdart.dart';

class BudgetController {
  final Budget? budget;
  final MainFilter filter;
  final Iterable<ExpenseRecordInfo> records;

  BudgetDraft _draft;
  final TextEditingController nameController;
  final MoneyFormatTextEditingController amountController;
  final TextEditingController currencyController;

  final _updateTrigger = PublishSubject<void>();
  late final StreamSubscription _subscription;

  final chartData = ValueNotifier<List<MoneyDateInfo>>([]);

  BudgetController(this.budget, this.filter, this.records)
    : _draft = budget?.let(BudgetDraft.fromBudget) ?? BudgetDraft(),
      nameController = TextEditingController(text: budget?.name ?? ''),
      amountController = MoneyFormatTextEditingController(
        cents: budget?.amount.amountInCents,
      ),
      currencyController = TextEditingController(
        text: budget?.currency.name ?? '',
      ) {
    nameController.addListener(_notify);
    amountController.addListener(_notify);
    currencyController.addListener(_notify);

    _subscription = _updateTrigger
        .debounceTime(const Duration(milliseconds: 300))
        .listen((_) => _onUpdate());

    _notify();
  }

  void _notify() => _updateTrigger.add(null);

  void _onUpdate() {
    final d = draft;
    final (startDate, endDate) = DateTimeUtils.getBudgetInterval(
      filter.startDate.value,
      filter.endDate.value,
    );

    final expenses = records
        .where((e) => e.currency.name == d.currencyName)
        .where((e) => d.expenseTypeUids.contains(e.type.uid))
        .map((e) => MoneyDateInfo(e.date, e.amount))
        .toList();

    // Sorting is crucial for the accumulation logic
    expenses.sort((a, b) => a.date.compareTo(b.date));

    final accumulated = accumulateBudget(startDate, endDate, expenses);
    chartData.value = accumulated.toList();
  }

  Iterable<MoneyDateInfo> accumulateBudget(
    DateTime startDate,
    DateTime endDate,
    List<MoneyDateInfo> expenses,
  ) sync* {
    final timeline = DateTimeUtils.iterate(startDate, endDate);
    Money current = const Money(amountInCents: 0);
    int ind = 0;
    for (DateTime d in timeline) {
      while (ind < expenses.length && d.isAfter(expenses[ind].date)) {
        current += expenses[ind].amount;
        ind++;
      }
      yield MoneyDateInfo(d, current);
    }
  }

  Set<String> get expenseTypeUids => _draft.expenseTypeUids;

  void setExpenseTypeUids(Set<String> uids) {
    _draft = _draft.copyWith(expenseTypeUids: uids);
    _notify();
  }

  void toggleExpenseTypeUid(String uid) {
    final uids = Set<String>.from(_draft.expenseTypeUids);
    if (uids.contains(uid)) {
      uids.remove(uid);
    } else {
      uids.add(uid);
    }
    _draft = _draft.copyWith(expenseTypeUids: uids);
    _notify();
  }

  String? get errorMessage {
    if (nameController.text.isEmpty) return 'Budget name is empty';
    if (amountController.amount <= 0) return 'The amount is zero';
    if (currencyController.text.isEmpty) return 'The currency is empty';
    if (expenseTypeUids.isEmpty) return 'No categories selected';
    return null;
  }

  BudgetDraft get draft {
    return BudgetDraft(
      uid: _draft.uid,
      name: nameController.text,
      amountInCents: amountController.amount,
      currencyName: currencyController.text,
      expenseTypeUids: expenseTypeUids,
    );
  }

  void dispose() {
    _subscription.cancel();
    _updateTrigger.close();
    chartData.dispose();
    nameController.dispose();
    amountController.dispose();
    currencyController.dispose();
  }
}
