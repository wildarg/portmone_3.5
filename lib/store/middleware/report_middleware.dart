import 'package:portmone_bloc/data/repo/reports_repo.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';

Middleware reportsMiddleware(ReportsRepo repo) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {

  if (action is RefreshAccountBalanceReportAction) {    
    _refreshAccountsBalance(store, repo, store.filterState.value);
  }

  await next(action);

  if (action is SetMainFilterAction) {
    _refreshReports(store, repo, action.filter);
  }

  if (action is SaveAccountAction) {
    _refreshReports(store, repo, store.filterState.value);
  }
};

void _refreshReports(PortmoneStore store, ReportsRepo repo, MainFilter filter) {
    _refreshTotalBalance(store, repo, filter);
    _refreshAccountsBalance(store, repo, filter);
    _refreshTotalExpense(store, repo, filter);
    _refreshTypedExpense(store, repo, filter);
    _refreshTotalIncome(store, repo, filter);
    _refreshTypedIncome(store, repo, filter);
}

void _refreshTotalBalance(PortmoneStore store, ReportsRepo repo, MainFilter filter) {
  Future(() async {
    final totalBalance = await repo.getTotalBalanceReport(filter);
    store.dispatch(SetTotalReportAction(data: totalBalance.toList()));
  });
}

void _refreshAccountsBalance(PortmoneStore store, ReportsRepo repo, MainFilter filter) {
  Future(() async {
    final accountBalance = await repo.getAccountBalanceReport(filter);
    store.dispatch(SetAccountBalanceReportAction(data: accountBalance.toList()));
  });
}

void _refreshTotalExpense(PortmoneStore store, ReportsRepo repo, MainFilter filter) {
  Future(() async {
    final totalExpense = await repo.getCurrencyExpenseReport(filter);
    store.dispatch(SetTotalExpenseReportAction(data: totalExpense.toList()));
  });
}

void _refreshTypedExpense(PortmoneStore store, ReportsRepo repo, MainFilter filter) {
  Future(() async {
    final data = await repo.getTypeExpenseReport(filter);
    store.dispatch(SetTypeExpenseReportAction(data.toList()));
  });
}

void _refreshTotalIncome(PortmoneStore store, ReportsRepo repo, MainFilter filter) {
  Future(() async {
    final totalIncome = await repo.getCurrencyIncomeReport(filter);
    store.dispatch(SetTotalIncomeReportAction(data: totalIncome.toList()));
  });
}

void _refreshTypedIncome(PortmoneStore store, ReportsRepo repo, MainFilter filter) {
  Future(() async {
    final data = await repo.getTypeIncomeReport(filter);
    store.dispatch(SetTypeIncomeReportAction(data.toList()));
  });
}
