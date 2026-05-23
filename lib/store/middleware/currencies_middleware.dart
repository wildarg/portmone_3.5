import 'package:portmone_bloc/data/repo/currencies_repo.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';

Middleware currenciesMiddlware(CurrenciesRepo repo) =>
    (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {
      if (action is InitAction) {
        Future(() async {
          final currencies = (await repo.getAll()).toList();
          store.dispatch(SetCurrencyListAction(currencies));
        });
      }

      // if (action is SaveAccountAction) {
      //   await repo.save(action.account);
      //   final accounts = (await repo.getAll()).toList();
      //   store.dispatch(SetAccountsAction(accounts));
      // }

      return next(action);
    };
