import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/get_account_ranged_balance_query.dart';
import 'package:portmone_bloc/data/db/query/get_currency_expense_report_query.dart';
import 'package:portmone_bloc/data/db/query/get_currency_income_report_query.dart';
import 'package:portmone_bloc/data/db/query/get_total_range_balance_query.dart';
import 'package:portmone_bloc/data/db/query/get_type_expense_report_query.dart';
import 'package:portmone_bloc/data/db/query/get_type_income_report_query.dart';
import 'package:portmone_bloc/model/account_ranged_info.dart';
import 'package:portmone_bloc/model/amount_type_info.dart';
import 'package:portmone_bloc/model/currency_info.dart';
import 'package:portmone_bloc/model/currency_range_info.dart';
import 'package:portmone_bloc/model/main_filter.dart';

class ReportsRepo {
  
  final PortmoneDB db;

  ReportsRepo({required this.db});

  Future<Iterable<CurrencyRangeInfo>> getTotalBalanceReport(MainFilter filter) {
    return GetTotalRangedBalanceQuery(db).execute(
      filter.startDate.value, 
      filter.endDate.value, 
      filter.plannedInclude
    );
  }

  Future<Iterable<AccountRangedInfo>> getAccountBalanceReport(MainFilter filter) {
    return GetAccountRangedBalanceQuery(db).execute(
      filter.startDate.value, 
      filter.endDate.value, 
      filter.plannedInclude
    );
  }

  Future<Iterable<CurrencyInfo>> getCurrencyExpenseReport(MainFilter filter) {
    return GetCurrencyExpenseReportQuery(db).execute(filter);
  }

  Future<Iterable<AmountTypeInfo>> getTypeExpenseReport(MainFilter filter) {
    return GetTypeExpenseReportQuery(db).execute(filter);
  }

  Future<Iterable<CurrencyInfo>> getCurrencyIncomeReport(MainFilter filter) {
    return GetCurrencyIncomeReportQuery(db).execute(filter);
  }

  Future<Iterable<AmountTypeInfo>> getTypeIncomeReport(MainFilter filter) {
    return GetTypeIncomeReportQuery(db).execute(filter);
  }

}