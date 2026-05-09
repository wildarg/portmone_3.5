

import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/model/budget.dart';

class BudgetChartData {
  final int timestamp;
  final int totalCents;
  BudgetChartData(this.timestamp, this.totalCents);
}

class GetBudgetDataQuery {

  final PortmoneDB db;

  GetBudgetDataQuery(this.db );

  Future<Iterable<BudgetChartData>> execute(
    final Budget budget,
    final DateTime? startDate,
    final DateTime? endDate,
    final bool plannedInclude
  ) async {
    final sql = _getSql(startDate, endDate, plannedInclude, budget.currency.uid, _getUidList(budget));
    final data = await db.query(sql);
    return data.map(_toBudgetData);
  }

  String _getSql(
    DateTime? startDate, 
    DateTime? endDate, 
    bool plannedInclude, 
    String currencyUid,
    String uidList
  ) {
    StringBuffer sql = StringBuffer('''
      select
        e.date,
        sum(e.amount) as amount
      from
        expenses e 
        left join accounts a on a.uid = e.accountUid
      where
        a.currencyUid = '$currencyUid'
        and e.planned <= ${plannedInclude? 1 : 0}
        and e.typeUid in ($uidList)
    ''');
    if (startDate != null) sql.write(' and e.date >= ${startDate.millisecondsSinceEpoch}');
    if (endDate != null) sql.write(' and e.date <= ${endDate.millisecondsSinceEpoch}');
    sql.write(' group by 1');
    sql.write(' order by 1');
    return sql.toString();
  }

  BudgetChartData _toBudgetData(Map<String, Object?> map) {
    return BudgetChartData(
      (map['date'] as num).toInt(), 
      (map['amount'] as num).toInt(),
    );
  }

  String _getUidList(Budget budget) =>
    budget.expenseTypeUids
      .map((s) => '"$s"')
      .join(',');

}