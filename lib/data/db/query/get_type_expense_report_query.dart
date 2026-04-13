import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/sql_query_extensions.dart';
import 'package:portmone_bloc/model/amount_type_info.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/model/named_amount.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class GetTypeExpenseReportQuery {
  
  final PortmoneDB _db;

  GetTypeExpenseReportQuery(this._db);

  Future<Iterable<AmountTypeInfo>> execute(MainFilter filter) async {
    final monthsSql = _monthsSql(filter.endDate.value?.millisecondsSinceEpoch);
    final months = await _db.query(monthsSql);
    final monthNames = months.map(
      (map) => [
        map.shortMonthName('prev_2_months'),
        map.shortMonthName('prev_month'),
        map.shortMonthName('current_month'),
      ]
    ).first;

    final sql = _getSql(filter);
    final list = await _db.query(sql);
    final result = list.map((e) => _toExpenseTypeInfo(e, monthNames))
      .where((e) => e.totalSpent.amountInCents > 0);
    return result;
  }

  String _getSql(MainFilter filter) {
    StringBuffer sql = StringBuffer('''
      SELECT 
          e.*,
          strftime('%Y-%m-01', e.date/1000, 'unixepoch', 'localtime', 'start of month') AS expense_month
      FROM expenses e
      WHERE 
        1 = 1
    ''');

    sql.addEndDate('e.date', filter.endDate.value);
    sql.addPlanned('e.planned', filter.plannedInclude);
    sql.addEntityUid('e.accountUid', filter.account.value?.uid);

    final startTimestamp = filter.startDate.value?.millisecondsSinceEpoch;
    final endTimestamp = filter.endDate.value?.millisecondsSinceEpoch;

    return """
      WITH FilteredExpenses AS ( ${sql.toString()} ),
      Months AS (
        ${ _monthsSql(endTimestamp) }        
      )
      SELECT 
          et.uid AS expense_type_uid,
          et.name AS expense_type_name,
          c.uid AS currencyUid,
          c.name AS currencyName,
          ${
            startTimestamp != null
              ? 'SUM(CASE WHEN fe.date >= $startTimestamp THEN fe.amount ELSE 0 END) AS total_spent,'
              : 'SUM(fe.amount) AS total_spent,'
          }                
          SUM(CASE WHEN fe.expense_month = m.prev_2_months THEN fe.amount ELSE 0 END) AS spent_prev_2_months,
          SUM(CASE WHEN fe.expense_month = m.prev_month THEN fe.amount ELSE 0 END) AS spent_prev_month,
          SUM(CASE WHEN fe.expense_month = m.current_month THEN fe.amount ELSE 0 END) AS spent_current_month
      FROM FilteredExpenses fe
      JOIN expenseTypes et ON fe.typeUid = et.uid
      JOIN accounts a ON fe.accountUid = a.uid
      LEFT JOIN currencies c ON a.currencyUid = c.uid
      JOIN Months m
      GROUP BY et.uid, et.name, c.uid, c.name
      order by et.name, c.name
    """;
  }

  String _monthsSql(int? endTimestamp) {
    return endTimestamp == null
      ? """        
        SELECT 
          strftime('%Y-%m-01', 'now', 'localtime', 'start of month', '-2 months') AS prev_2_months,
          strftime('%Y-%m-01', 'now', 'localtime', 'start of month', '-1 month') AS prev_month,
          strftime('%Y-%m-01', 'now', 'localtime', 'start of month') AS current_month
      """
      : """
        SELECT 
          strftime('%Y-%m-01', ${endTimestamp/1000}, 'unixepoch', 'localtime', 'start of month', '-2 months') AS prev_2_months,
          strftime('%Y-%m-01', ${endTimestamp/1000}, 'unixepoch', 'localtime', 'start of month', '-1 month') AS prev_month,
          strftime('%Y-%m-01', ${endTimestamp/1000}, 'unixepoch', 'localtime', 'start of month') AS current_month
      """;
  }

  AmountTypeInfo _toExpenseTypeInfo(Map<String, Object?> map, List<String> monthNames) {
    return AmountTypeInfo(
      type: TransactionType(
        uid: map.getString('expense_type_uid') ?? '',
        name: map.getString('expense_type_name') ?? ''
      ), 
      currency: map.getCurrency(), 
      totalSpent: map.getMoney('total_spent'),
      chartData: [
        NamedAmount(map.getMoney('spent_prev_2_months'), monthNames[0]),
        NamedAmount(map.getMoney('spent_prev_month'), monthNames[1]),
        NamedAmount(map.getMoney('spent_current_month'), monthNames[2]),
      ]
    );
  }

}

extension MapDateTimeExtenstion on Map<String, Object?> {

  String shortMonthName(String key) {
    final stringDate = this[key] as String;
    final date = stringDate.asDateTime;
    return date.shortMonthName();
  }

}