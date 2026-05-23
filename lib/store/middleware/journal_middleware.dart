import 'package:collection/collection.dart';
import 'package:portmone_bloc/data/repo/journal_repo.dart';
import 'package:portmone_bloc/model/date_transactions.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';

Middleware journalMiddleware(JournalRepo repo) =>
    (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {
      if (action is RefreshJournalAction) {
        _refreshJournal(store, repo, store.filterState.value);
      }

      await next(action);

      if (action is SetMainFilterAction) {
        _refreshJournal(store, repo, action.filter);
      }

      if (action is SaveAccountAction) {
        _refreshJournal(store, repo, store.filterState.value);
      }

      if (action is SetTextFilterAction) {
        MainFilter filter = store.filterState.value.copyWith(text: action.text);
        _refreshJournal(store, repo, filter);
      }
    };

void _refreshJournal(
  PortmoneStore store,
  JournalRepo repo,
  MainFilter filter,
) => Future(() async {
  final records = await repo.getJournal(filter);
  final journal = groupBy(records, (r) => r.date.withoutTime).entries
      .sorted((one, other) => other.key.compareTo(one.key))
      .map((e) => DateTransactions(dateTime: e.key, transactions: e.value))
      .toList();
  store.dispatch(SetJournalAction(journal));
});
