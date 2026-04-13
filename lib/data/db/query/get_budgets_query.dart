import 'package:portmone/data/db/portmone_db.dart';
import 'package:portmone/data/db/scheme.dart';
import 'package:portmone/domain/model/budget_entity.dart';
import 'package:portmone/domain/model/currency.dart';
import 'package:portmone/utils/extensions.dart';

class GetBudgetsQuery {

  final PortmoneDB db;

  GetBudgetsQuery(this.db);

  Future<Iterable<Budget>> execute() async {
    final sql = _getSql();
    final list = await db.query(sql);
    final result = list.map(_toBudget);
    return result;
  }

  String _getSql() {
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
        l.uids
      from
        budget b
        left join currencies c on c.uid = b.currencyUid
        left join expenseTypeLink l on l.budgetUid = b.uid
      order by
        b.uid  
  ''';
  }

  Budget _toBudget(Map<String, Object?> map) {
    return Budget(
      uid: map.getString(BudgetTable.uid),
      name: map.getString(BudgetTable.name) ?? '',
      currency: Currency(
        uid: map.getString(BudgetTable.currencyUid),
        name: map.getString('currencyName') ?? ''
      ),
      amount: map.getAmount('amount'),
      expenseTypeUids: map.getString('uids')?.split(',') ?? []
    );
  }

}