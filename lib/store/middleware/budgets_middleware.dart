import 'package:portmone_bloc/data/repo/budgets_repo.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';

Middleware tagsMiddlware(BudgetRepo repo) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {

  if (action is InitAction) {
    _refreshBudgets(store, repo);
  }

  await next(action);

  if (action is SaveTransactionAction) {
    _refreshBudgets(store, repo);
  }
};

Future<void> _refreshBudgets(PortmoneStore store, BudgetRepo repo) async {
    Future(() async {
      final list = (await repo.getBudgets()).toList();
      store.dispatch(SetBudgetsAction(list));
    });
}