
import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/sql_query_extensions.dart';
import 'package:portmone_bloc/model/currency_info.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class GetCurrencyExpenseReportQuery {
  
  final PortmoneDB _db;

  GetCurrencyExpenseReportQuery(this._db);

  Future<Iterable<CurrencyInfo>> execute(MainFilter filter) async {
    final sql = _getSql(filter);
    final list = await _db.query(sql);
    final result = list.map(_toExpenseCurrencyInfo);
    return result;    
  }

  String _getSql(MainFilter filter) {
    StringBuffer sql = StringBuffer("""
      select 
          e.*
      from expenses e
      where
        1 = 1
    """);
    sql.addStartDate('e.date', filter.startDate.value);
    sql.addEndDate('e.date', filter.endDate.value);
    sql.addPlanned('e.planned', filter.plannedInclude);
    sql.addEntityUid('e.accountUid', filter.account.value?.uid);

    return """
      WITH FilteredExpenses AS ( ${sql.toString()} )
      SELECT 
          c.uid AS currencyUid,
          c.name AS currencyName,
          SUM(fe.amount) AS total_spent
      FROM FilteredExpenses fe
      JOIN accounts a ON fe.accountUid = a.uid
      LEFT JOIN currencies c ON a.currencyUid = c.uid
      GROUP BY c.uid, c.name
      order by c.name
    """;
  }


  CurrencyInfo _toExpenseCurrencyInfo(Map<String, Object?> map) {
    return CurrencyInfo(
      currency: map.getCurrency(), 
      amount: map.getMoney('total_spent')
    );
  }


}
