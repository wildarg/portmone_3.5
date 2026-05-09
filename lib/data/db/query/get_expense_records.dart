
import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/sql_query_extensions.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/expense_record_info.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class GetExpenseRecordsQuery {

  final PortmoneDB db;

  GetExpenseRecordsQuery(this.db);

  Future<Iterable<ExpenseRecordInfo>> execute(
    DateTime? startDate,
    DateTime? endDate,
    bool isPlannedIncluded,
  ) async {
    final sql = _getSql(startDate, endDate, isPlannedIncluded);
    final list = await db.query(sql);
    return list.map(_toExpenseRecordInfo);
  }

  ExpenseRecordInfo _toExpenseRecordInfo(Map<String, Object?> map) {
    return ExpenseRecordInfo(
      date: map.getDateTime('date')!,
      type: TransactionType(
        uid: map.getString('type_uid')!, 
        name: map.getString('type_name')!
      ),
      currency: Currency(
        uid: map.getString('currency_uid')!, 
        name: map.getString('currency_name')!
      ),
      amount: map.getMoney('amount')
    );
  }  

  String _getSql(
    DateTime? startDate,
    DateTime? endDate,
    bool isPlannedIncluded,
  ) {
    StringBuffer sql = StringBuffer('''
      select
        e.${ExpensesTable.date} as date,
        et.${ExpenseTypesTable.uid} as type_uid,
        et.${ExpenseTypesTable.name} as type_name,
        c.uid as currency_uid,
        c.name as currency_name,
        sum(e.amount) as amount
      from 
        expenses e
        left join accounts a on a.uid = e.accountUid
        left join currencies c on c.uid = a.currencyUid
        left join ${ExpenseTypesTable.tableName} et on et.${ExpenseTypesTable.uid} = e.${ExpensesTable.typeUid}
      where
        1 = 1
    ''');

    sql.addStartDate('e.date', startDate);
    sql.addEndDate('e.date', endDate);
    sql.addPlanned('e.planned', isPlannedIncluded);
    sql.write(' group by 1, 2, 3, 4, 5');
    return sql.toString();
  }

}