import 'package:portmone_bloc/data/repo/budgets_repo.dart';
import 'package:portmone_bloc/data/repo/currencies_repo.dart';
import 'package:portmone_bloc/model/budget.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';

Middleware budgetMiddlware(BudgetRepo repo, CurrenciesRepo currenciesRepo) =>
    (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {
      if (action is InitAction) {
        _refreshBudgets(store, repo);
      }

      if (action is SaveBudgetAction) {
        final d = action.draft;
        final currency = await currenciesRepo.getOrSave(
          d.currencyName ?? 'USD',
        );

        final budget = Budget(
          uid: d.uid ?? repo.db.getNewUid(),
          name: d.name ?? '',
          amount: Money(amountInCents: d.amountInCents ?? 0),
          currency: currency,
          expenseTypeUids: d.expenseTypeUids.toList(),
        );

        await repo.saveBudget(budget);
        _refreshBudgets(store, repo);
      }

      if (action is DeleteBudgetAction) {
        await repo.deleteBudget(action.budget);
        _refreshBudgets(store, repo);
      }

      await next(action);

      if (action is SaveTransactionAction) {
        _refreshBudgets(store, repo);
      }
      if (action is SetMainFilterAction) {
        _refreshBudgets(store, repo);
      }
    };

void _refreshBudgets(PortmoneStore store, BudgetRepo repo) {
  final filter = store.filterState.value;

  Future(() async {
    final list = (await repo.getBudgets(filter)).toList();
    store.dispatch(SetBudgetsAction(list));
  });
  Future(() async {
    final list = (await repo.getExpenseRecordInfo(filter)).toList();
    store.dispatch(SetExpenseRecordInfoAction(list));
  });
}
