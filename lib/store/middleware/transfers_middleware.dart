import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'package:portmone_bloc/data/repo/accounts_repo.dart';
import 'package:portmone_bloc/data/repo/currencies_repo.dart';
import 'package:portmone_bloc/data/repo/tags_repo.dart';
import 'package:portmone_bloc/data/repo/transfers_repo.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/model/transfer_draft.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

Middleware transfersMiddleware(
  TransfersRepo transferRepo,
  AccountsRepo accountsRepo,
  CurrenciesRepo currenciesRepo,
  TagsRepo tagsRepo,
) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {
  if (action is SaveTransferAction) {
    unawaited(
      _saveTransfer(
        action.draft,
        transferRepo,
        accountsRepo,
        currenciesRepo,
        tagsRepo,
        store,
      ),
    );
  }

  if (action is DeleteTransferAction) {
    unawaited(
      Future(() async {
        await transferRepo.deleteByUid(action.transfer.uid);
        store.dispatch(RefreshJournalAction());
      }),
    );
  }

  if (action is RestoreTransferAction) {
    unawaited(
      Future(() async {
        await transferRepo.save(action.transfer);
        store.dispatch(RefreshJournalAction());
      }),
    );
  }

  return next(action);
};

Future<void> _saveTransfer(
  TransferDraft draft,
  TransfersRepo transferRepo,
  AccountsRepo accountsRepo,
  CurrenciesRepo currenciesRepo,
  TagsRepo tagsRepo,
  PortmoneStore store,
) async {
  try {
    final fromCurrency = await currenciesRepo.getOrSave(
      draft.fromCurrencyName!,
    );
    final fromAccount = await accountsRepo.getOrSave(
      draft.fromAccountName!,
      fromCurrency,
    );

    final toCurrency = await currenciesRepo.getOrSave(draft.toCurrencyName!);
    final toAccount = await accountsRepo.getOrSave(
      draft.toAccountName!,
      toCurrency,
    );

    final transfer = Transfer(
      uid: draft.uid ?? '',
      date: draft.date!,
      timestamp: draft.timestamp ?? DateTime.now(),
      isPending: draft.isPending ?? false,
      notes: draft.notes ?? '',
      fromAccount: fromAccount,
      fromAmount: Money(amountInCents: draft.fromAmountInCents!),
      toAccount: toAccount,
      toAmount: Money(amountInCents: draft.toAmountInCents!),
    );

    await transferRepo.save(transfer);
    store.dispatch(RefreshJournalAction());
    tagsRepo.putTags(transfer.notes.hashTags);
  } catch (e) {
    log('error on save transfer, $e');
  }
}
