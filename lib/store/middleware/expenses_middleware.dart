import 'package:portmone_bloc/data/repo/accounts_repo.dart';
import 'package:portmone_bloc/data/repo/currencies_repo.dart';
import 'package:portmone_bloc/data/repo/expense_types_repo.dart';
import 'package:portmone_bloc/data/repo/expenses_repo.dart';
import 'package:portmone_bloc/data/repo/tags_repo.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

Middleware expensesMiddleware(
  ExpensesRepo expenseRepo,
  ExpenseTypesRepo expenseTypesRepo,
  AccountsRepo accountsRepo,
  CurrenciesRepo currenciesRepo,
  TagsRepo tagsRepo,
) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {

  if (action is SaveExpenseAction) {
    Future(() async {
      final draft = action.draft;
      final type = await expenseTypesRepo.getOrSave(draft.typeName!);
      final currency = await currenciesRepo.getOrSave(draft.currencyName!);
      final account = await accountsRepo.getOrSave(draft.accountName!, currency);
      final expense = Expense(
        uid: draft.uid ?? '',
        date: draft.date!,
        timestamp: draft.timestamp ?? DateTime.now(),
        isPending: draft.isPending ?? false,
        notes: draft.notes ?? '',
        type: type,
        account: account,
        amount: Money(amountInCents: draft.amountInCents!)
      );
      await expenseRepo.save(expense);
      store.dispatch(RefreshJournalAction());
      tagsRepo.putTags(expense.notes.hashTags);
    });
  }

  return next(action);
};