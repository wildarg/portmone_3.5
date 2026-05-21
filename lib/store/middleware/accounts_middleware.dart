import 'package:portmone_bloc/data/repo/accounts_repo.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';

Middleware accountsMiddlware(AccountsRepo repo) =>
    (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {
      if (action is InitAction) {
        final accounts = (await repo.getAll()).toList();
        store.dispatch(SetAccountsAction(accounts));
      }

      if (action is SaveAccountAction) {
        await repo.save(action.account);
        final accounts = (await repo.getAll()).toList();
        store.dispatch(SetAccountsAction(accounts));
      }

      if (action is SetAccountOrderAction) {
        Future(() async {
          await repo.updatePosition(action.accounts);
          store.dispatch(RefreshAccountBalanceReportAction());
        });
      }

      return next(action);
    };
