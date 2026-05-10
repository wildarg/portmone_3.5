import 'package:portmone_bloc/data/repo/main_filter_repo.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/utils/nullable.dart';

Middleware mainFilterMiddleware(MainFilterRepo repo) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {

  if (action is InitAction) {
    _refreshMainFilter(store, repo);
  }

  if (action is UpdateMainFilterAction) {
    Future(() async {
      store.dispatch(SetMainFilterAction(filter: action.filter));
      await repo.save(action.filter);      
    });
  }

  if (action is SetAccountFilterAction) {
    Future(() {
      final filter = store.filterState.value;
      final newFilter = filter.copyWith(
        account: Nullable<Account>(action.account)
      );
      store.dispatch(UpdateMainFilterAction(filter: newFilter));
    });
  }

  if (action is SetTextFilterAction) {
    Future(() {
      final filter = store.filterState.value;
      final newFilter = filter.copyWith(
        text: action.text
      );
      repo.save(newFilter);
      // store.dispatch(UpdateMainFilterAction(filter: newFilter));
    });
  }

  return next(action);
};

Future<void> _refreshMainFilter(PortmoneStore store, MainFilterRepo repo) async {
  final filter = await repo.getMainFilter();
  store.dispatch(SetMainFilterAction(filter: filter));
}