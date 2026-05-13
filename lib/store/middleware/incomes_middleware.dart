import 'package:portmone_bloc/data/repo/accounts_repo.dart';
import 'package:portmone_bloc/data/repo/currencies_repo.dart';
import 'package:portmone_bloc/data/repo/income_types_repo.dart';
import 'package:portmone_bloc/data/repo/incomes_repo.dart';
import 'package:portmone_bloc/data/repo/tags_repo.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

Middleware incomesMiddleware(
  IncomesRepo incomeRepo,
  IncomeTypesRepo incomeTypesRepo,
  AccountsRepo accountsRepo,
  CurrenciesRepo currenciesRepo,
  TagsRepo tagsRepo,
) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {

  if (action is SaveIncomeAction) {
    Future(() async {
      final draft = action.draft;
      final type = await incomeTypesRepo.getOrSave(draft.typeName!);
      final currency = await currenciesRepo.getOrSave(draft.currencyName!);
      final account = await accountsRepo.getOrSave(draft.accountName!, currency);
      final income = Income(
        uid: draft.uid ?? '',
        date: draft.date!,
        timestamp: draft.timestamp ?? DateTime.now(),
        isPending: draft.isPending ?? false,
        notes: draft.notes ?? '',
        type: type,
        account: account,
        amount: Money(amountInCents: draft.amountInCents!)
      );
      await incomeRepo.save(income);
      store.dispatch(RefreshJournalAction());
      tagsRepo.putTags(income.notes.hashTags);
    });
  }

  if (action is DeleteIncomeAction) {
    Future(() async {
      await incomeRepo.deleteByUid(action.income.uid);
      store.dispatch(RefreshJournalAction());
    });
  }

  if (action is RestoreIncomeAction) {
    Future(() async {
      await incomeRepo.save(action.income);
      store.dispatch(RefreshJournalAction());
    });
  }

  return next(action);
};
