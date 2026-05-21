import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';
import 'package:portmone_bloc/utils/nullable.dart';

class MainFilterRepo {

  final PortmoneDB db;

  MainFilterRepo({required this.db});

  Future<MainFilter> getMainFilter() async {
    final sql = '''
    select
      mf.*,
      a.name as accountName,
      a.currencyUid,
      c.name as currencyName,
      it.name as incomeTypeName,
      et.name as expenseTypeName
    from
      mainFilter mf
      left join accounts a on a.uid = accountUid
      left join currencies c on c.uid = a.currencyUid 
      left join incomeTypes it on it.uid = mf.incomeTypeUid
      left join expenseTypes et on et.uid = mf.expenseTypeUid
    ''';
    final map = (await db.query(sql))
      .firstOrNull ?? {};
    return _fromMap(map);
  }

  Future<MainFilter> save(MainFilter filter) async {
    Map<String, dynamic> map = _toMap(filter);
    await db.insert(MainFilterTable.tableName, map);
    return filter;
  }

  MainFilter _fromMap(Map<String, dynamic> map) {
    return MainFilter(
      id: map.getInt('id') ?? 0,
      startDate: Nullable<DateTime>(map.getDateTime('startDate')),
      endDate: Nullable<DateTime>(map.getDateTime('endDate')),
      plannedInclude: map.getBool('plannedInclude'),
      text: map.getString('text') ?? '',
      account: Nullable<Account>(map.optAccount()),
      transactionType: Nullable<TransactionType>(map.optTransactionType('incomeType')),
      // incomeType: map.optOperationType('incomeType'),
      // expenseType: map.optOperationType('expenseType'),
      // tag: map.getString('tag')
    );
  }
  
  Map<String, dynamic> _toMap(MainFilter filter) => {
    MainFilterTable.id : filter.id,
    MainFilterTable.startDate : filter.startDate.value?.millisecondsSinceEpoch,
    MainFilterTable.endDate : filter.endDate.value?.millisecondsSinceEpoch,
    MainFilterTable.plannedInclude : filter.plannedInclude? 1 : 0,
    MainFilterTable.accountUid : filter.account.value?.uid,
    MainFilterTable.incomeTypeUid : filter.transactionType.value?.uid,
    MainFilterTable.text : filter.text,
  };


}