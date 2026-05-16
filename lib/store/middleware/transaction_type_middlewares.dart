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

  if (action is UpdateExpenseTypeAction) {
    await repo.update(action.transactionType);
    final list = (await repo.getAll()).toList();
    store.dispatch(SetExpenseTypesAction(list));
  }

  return next(action);
};

Middleware incomeTypesMiddlware(IncomeTypesRepo repo) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {

  if (action is InitAction) {
    Future(() async {
      final list = (await repo.getAll()).toList();
      store.dispatch(SetIncomeTypesAction(list));
    });
  }

  if (action is UpdateIncomeTypeAction) {
    await repo.update(action.transactionType);
    final list = (await repo.getAll()).toList();
    store.dispatch(SetIncomeTypesAction(list));
  }

  return next(action);
};