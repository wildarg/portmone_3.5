import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/sql_query_extensions.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/budget.dart';
import 'package:portmone_bloc/model/budget_info.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class GetBudgetsQuery {
  final PortmoneDB db;

  GetBudgetsQuery(this.db);

  Future<Iterable<BudgetInfo>> execute(
    DateTime? startDate,
    DateTime? endDate,
    bool isPlannedIncluded,
  ) async {
    final sql = _getSql(startDate, endDate, isPlannedIncluded);
    final list = await db.query(sql);
    final result = list.map(_toBudgetInfo);
    return result;
  }

  String _getSql(
    DateTime? startDate,
    DateTime? endDate,
    bool isPlannedIncluded,
  ) {
    StringBuffer sql = StringBuffer('''
      select
        sum(amount)
      from
        expenses e
        left join accounts a on a.uid = e.accountUid
      where
        a.currencyUid = b.currencyUid
        and e.typeUid in (select bl.expenseTypeUid from budgetLink bl where bl.budgetUid = b.uid)
    ''');
    sql.addStartDate('e.date', startDate);
    sql.addEndDate('e.date', endDate);
    sql.addPlanned('e.planned', isPlannedIncluded);

    return '''
      with expenseTypeLink as (
        select 
          bl.budgetUid,
          group_concat(bl.expenseTypeUid) as uids
        from
          budgetLink bl
        group by
          1
      )
      select 
        b.*,
        c.name as currencyName,
        l.uids,
        ( ${sql.toString()} ) as spent
      from 
        budget b
        left join currencies c on b.currencyUid = c.uid
        left join expenseTypeLink l on l.budgetUid = b.uid
      order by 
        b.name  
    ''';
  }

  BudgetInfo _toBudgetInfo(Map<String, Object?> map) {
    Budget budget = Budget(
      uid: map.getString(BudgetTable.uid) ?? '',
      name: map.getString(BudgetTable.name) ?? '',
      currency: Currency(
        uid: map.getString(BudgetTable.currencyUid) ?? '',
        name: map.getString('currencyName') ?? '',
      ),
      amount: map.getMoney(BudgetTable.amount),
      expenseTypeUids: map.getString('uids')?.split(',') ?? [],
    );
    return BudgetInfo(budget: budget, spent: map.getMoney('spent'));
  }
}
