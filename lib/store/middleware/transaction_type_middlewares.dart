import 'package:portmone_bloc/data/repo/expense_types_repo.dart';
import 'package:portmone_bloc/data/repo/income_types_repo.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';

Middleware expenseTypesMiddlware(ExpenseTypesRepo repo) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {

  if (action is InitAction) {
    Future(() async {
      final list = (await repo.getAll()).toList();
      store.dispatch(SetExpenseTypesAction(list));
    });
  }

  // if (action is SaveAccountAction) {
  //   await repo.save(action.account);
  //   final accounts = (await repo.getAll()).toList();
  //   store.dispatch(SetAccountsAction(accounts));
  // }

  return next(action);
};

Middleware incomeTypesMiddlware(IncomeTypesRepo repo) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {

  if (action is InitAction) {
    Future(() async {
      final list = (await repo.getAll()).toList();
      store.dispatch(SetIncomeTypesAction(list));
    });
  }

  // if (action is SaveAccountAction) {
  //   await repo.save(action.account);
  //   final accounts = (await repo.getAll()).toList();
  //   store.dispatch(SetAccountsAction(accounts));
  // }

  return next(action);
};