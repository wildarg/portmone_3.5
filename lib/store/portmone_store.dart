import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/account_ranged_info.dart';
import 'package:portmone_bloc/model/amount_tracker_info.dart';
import 'package:portmone_bloc/model/amount_type_info.dart';
import 'package:portmone_bloc/model/budget.dart';
import 'package:portmone_bloc/model/budget_info.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/currency_info.dart';
import 'package:portmone_bloc/model/currency_range_info.dart';
import 'package:portmone_bloc/model/date_transactions.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';


typedef NextDispatcher = Future<void> Function(PortmoneAction action);

typedef Reducer = Future<void> Function(PortmoneStore store, PortmoneAction action);

typedef Middleware = Future<void> Function(PortmoneStore store, PortmoneAction action, NextDispatcher next);


class PortmoneStore {

  final List<Middleware> _middlewares;
  late NextDispatcher _dispatcher;

  BehaviorSubject<List<Account>> accountsState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<Currency>> currenciesState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<TransactionType>> expenseTypesState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<TransactionType>> incomeTypesState = BehaviorSubject.seeded(const []);
  BehaviorSubject<MainFilter> filterState = BehaviorSubject.seeded(MainFilter.empty);
  BehaviorSubject<List<CurrencyRangeInfo>> totalBalanceState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<AccountRangedInfo>> accountBalanceState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<CurrencyInfo>> totalExpenseState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<AmountTypeInfo>> typedExpenseState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<CurrencyInfo>> totalIncomeState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<AmountTypeInfo>> typedIncomeState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<DateTransactions>> journalState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<String>> tagsState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<AmountTrackerData>> expenseTrackerState = BehaviorSubject.seeded(const []);
  BehaviorSubject<List<BudgetInfo>> budgetState = BehaviorSubject.seeded(const []);

  PortmoneStore(this._middlewares) {
    _dispatcher = _createDispatcher();
    Future.delayed(Durations.medium1, () => dispatch(InitAction()));
  }

  Future<void> _reducer(PortmoneStore store, PortmoneAction action) async {
    return switch (action) {
      SetAccountsAction() => accountsState.sink.add(action.accounts),
      SetMainFilterAction() => filterState.sink.add(action.filter),
      SetTotalReportAction() => totalBalanceState.sink.add(action.data),
      SetAccountBalanceReportAction() => accountBalanceState.sink.add(action.data),
      SetTotalExpenseReportAction() => totalExpenseState.sink.add(action.data),
      SetTypeExpenseReportAction() => typedExpenseState.sink.add(action.data),
      SetTotalIncomeReportAction() => totalIncomeState.sink.add(action.data),
      SetTypeIncomeReportAction() => typedIncomeState.sink.add(action.data),
      SetJournalAction() => journalState.sink.add(action.journal),
      SetCurrencyListAction() => currenciesState.sink.add(action.list),
      SetIncomeTypesAction() => incomeTypesState.sink.add(action.list),
      SetExpenseTypesAction() => expenseTypesState.sink.add(action.list),
      SetTagsAction() => tagsState.sink.add(action.list),
      SetExpenseTrackersAction() => expenseTrackerState.sink.add(action.data),
      SetBudgetsAction() => budgetState.sink.add(action.list),
      _ => null
    };
  }

  NextDispatcher _createDispatcher() {
    final dispatchers = <NextDispatcher>[(PortmoneAction action) => _reducer(this, action)];
    for (var middleware in _middlewares.reversed) {
      final next = dispatchers.last;
      dispatchers.add((PortmoneAction action) => middleware(this, action, next));
    }
    return dispatchers.last;
  }

  Future<void> dispatch(PortmoneAction action) {
    return _dispatcher(action);
  }

}

extension StoreExtensions on BuildContext {

  Future<void> dispatch(PortmoneAction action) {
    final store = read<PortmoneStore>();
    return store.dispatch(action);
  }

  PortmoneStore get store => read<PortmoneStore>();

}