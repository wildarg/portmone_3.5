import 'package:portmone_bloc/data/db/portmone_db.dart';

class ExpenseTrackerResult {
  final String? currencyUid;
  final String? currencyName;
  final int firstAmount;
  final int secondAmount;

  ExpenseTrackerResult({
    required this.currencyUid,
    required this.currencyName,
    required this.firstAmount,
    required this.secondAmount,
  });
}

class GetExpenseTrackerQuery {
  final PortmoneDB db;

  GetExpenseTrackerQuery(this.db);

  Future<Iterable<ExpenseTrackerResult>> execute(
    int firstStart,
    int firstEnd,
    int secondStart,
    int secondEnd,
    bool includePlanned,
  ) async {
    final sql = _getSql(
      firstStart,
      firstEnd,
      secondStart,
      secondEnd,
      includePlanned ? 1 : 0,
    );
    final list = await db.query(sql);
    return list.map(_toExpenseTrackerResult);
  }

  ExpenseTrackerResult _toExpenseTrackerResult(Map<String, Object?> map) {
    return ExpenseTrackerResult(
      currencyUid: map['currencyUid'] as String?,
      currencyName: map['currencyName'] as String?,
      firstAmount: (map['firstAmount'] as num).toInt(),
      secondAmount: (map['secondAmount'] as num).toInt(),
    );
  }

  String _getSql(
    int firstStart,
    int firstEnd,
    int secondStart,
    int secondEnd,
    int includePlanned,
  ) {
    return '''
      select 
        c.uid as currencyUid,
        c.name as currencyName,	
        sum(
          case 
            when e.date BETWEEN $firstStart and $firstEnd then e.amount
            else 0
          end
        ) as firstAmount,
        sum(e.amount) as secondAmount
      from 
        expenses e
        left join accounts a on a.uid = e.accountUid
        left join currencies c on c.uid = a.currencyUid
      where
        e.date BETWEEN $secondStart and $secondEnd
        and planned <= $includePlanned
      group by
        1, 2
      order by
        3 desc, 4 desc	
    ''';
  }
}
