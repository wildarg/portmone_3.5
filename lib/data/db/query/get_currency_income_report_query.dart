import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/sql_query_extensions.dart';
import 'package:portmone_bloc/model/currency_info.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class GetCurrencyIncomeReportQuery {
  final PortmoneDB _db;

  GetCurrencyIncomeReportQuery(this._db);

  Future<Iterable<CurrencyInfo>> execute(MainFilter filter) async {
    final sql = _getSql(filter);
    final list = await _db.query(sql);
    final result = list.map(_toAmountCurrencyInfo);
    return result;
  }

  String _getSql(MainFilter filter) {
    StringBuffer sql = StringBuffer("""
      select 
          e.*
      from incomes e
      where
        1 = 1
    """);
    sql.addStartDate('e.date', filter.startDate.value);
    sql.addEndDate('e.date', filter.endDate.value);
    sql.addPlanned('e.planned', filter.plannedInclude);
    sql.addEntityUid('e.accountUid', filter.account.value?.uid);

    return """
      WITH FilteredIncomes AS ( ${sql.toString()} )
      SELECT 
          c.uid AS currencyUid,
          c.name AS currencyName,
          SUM(fe.amount) AS total_earn
      FROM FilteredIncomes fe
      JOIN accounts a ON fe.accountUid = a.uid
      LEFT JOIN currencies c ON a.currencyUid = c.uid
      GROUP BY c.uid, c.name
      order by c.name
    """;
  }

  CurrencyInfo _toAmountCurrencyInfo(Map<String, Object?> map) {
    return CurrencyInfo(
      currency: map.getCurrency(),
      amount: map.getMoney('total_earn'),
    );
  }
}
