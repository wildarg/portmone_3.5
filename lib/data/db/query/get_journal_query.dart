import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/sql_query_extensions.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/model/transaction.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class GetJournalQuery {

  final PortmoneDB db;

  GetJournalQuery(this.db);

  Future<Iterable<Transaction>> execute(MainFilter filter) async {
    final sql = _getSql(filter);
    final list = await db.query(sql);
    final result = list.map(_toTransaction);
    return result;
  }

  Transaction _toTransaction(Map<String, Object?> map) {
    int? operation = map.getInt('operation');
    switch (operation) {
      case -1: return _createExpense(map);
      case  1: return _createIncome(map);
      case  0: return _createTransfer(map);
      default: throw Exception("Unknown operation type: $operation");
    }
  }


  String _getSql(MainFilter filter) {
    StringBuffer sql = StringBuffer("""
      select
        o.*,
        fa.name as fromAccountName,
        fc.name as fromCurrencyName,
        fc.uid as fromCurrencyUid,
        ta.name as toAccountName,
        tc.name as toCurrencyName,
        tc.uid as toCurrencyUid
      from
        (
          ${_getExpensesSQL(filter)}
          union all
          ${_getIncomesSQL(filter)} 
          union all
          ${_getTransfersSQL(filter)} 
        ) o
        left join accounts fa on fa.uid = o.fromAccountUid
        left join accounts ta on ta.uid = o.toAccountUid
        left join currencies fc on fc.uid = fa.currencyUid
        left join currencies tc on tc.uid = ta.currencyUid 
      where 
        1 = 1 
    """); 
      
    // sql.addNoteFilter('fa.name||fc.name||ta.name||tc.name||o.description||o.typeName', config.text);
    sql.addTextFilter(['o.description', 'o.typeName', 'fa.name', 'fc.name', 'ta.name', 'tc.name'], filter.text);
    sql.write(' order by o.date desc, o.timestamp desc, o.uid desc');
    return sql.toString();
  }

  String _getExpensesSQL(MainFilter filter) {
    StringBuffer sql = StringBuffer("""
      select 
        e.uid as uid,
        -1 as operation,
        e.date as date,
        e.timestamp as timestamp,
        e.planned as planned,
        e.typeUid as typeUid,
        et.name as typeName,
        e.accountUid as fromAccountUid,
        null as toAccountUid,
        e.amount as fromAmount,
        null as toAmount,
        e.description as description
      from 
        expenses e
        join expenseTypes et on et.uid = e.typeUid
      where
        1 = 1  
    """);
    sql.addStartDate('e.date', filter.startDate.value);
    sql.addEndDate('e.date', filter.endDate.value);
    sql.addPlanned('e.planned', filter.plannedInclude);
    sql.addEntityUid('e.accountUid', filter.account.value?.uid);
    sql.addEntityUid('e.typeUid', filter.transactionType.value?.uid);
    // sql.takeUnless(config.expenseType == null && config.incomeType != null);
    return sql.toString();  
  }

  String _getIncomesSQL(MainFilter filter) {
    StringBuffer sql = StringBuffer("""
      select 
        i.uid as uid,
        1 as operation,
        i.date as date,
        i.timestamp as timestamp,
        i.planned as planned,
        i.typeUid as typeUid,
        it.name as typeName,
        null as fromAccountUid,
        i.accountUid as toAccountUid,
        null as fromAmount,
        i.amount as toAmount,
        i.description as description
      from 
        incomes i
        join incomeTypes it on it.uid = i.typeUid
      where
        1 = 1  
    """);
    sql.addStartDate('i.date', filter.startDate.value);
    sql.addEndDate('i.date', filter.endDate.value);
    sql.addPlanned('i.planned', filter.plannedInclude);
    sql.addEntityUid('i.accountUid', filter.account.value?.uid);
    sql.addEntityUid('i.typeUid', filter.transactionType.value?.uid);
    // sql.takeUnless(config.expenseType != null && config.incomeType == null);
    return sql.toString();  
  }

  String _getTransfersSQL(MainFilter filter) {
    StringBuffer sql = StringBuffer("""
      select 
        t.uid as uid,
        0 as operation,
        t.date as date,
        t.timestamp as timestamp,
        t.planned as planned,
        null as typeUid,
        null as typeName,
        t.fromAccountUid as fromAccountUid,
        t.toAccountUid as toAccountUid,
        t.fromAmount as fromAmount,
        t.toAmount as toAmount,
        t.description as description
      from 
        transfers t
      where
        1 = 1  
    """);
    sql.addStartDate('t.date', filter.startDate.value);
    sql.addEndDate('t.date', filter.endDate.value);
    sql.addPlanned('t.planned', filter.plannedInclude);
    // sql.addNoteFilter('t.description', config.text);
    sql.addAccountSet(filter.account.value, ['t.fromAccountUid', 't.toAccountUid']);
    sql.takeUnless(filter.transactionType.hasData);
    return sql.toString();  
  }

  Account _getAccount(String prefix, Map<String, Object?> map) {
    Currency? currency = map["${prefix}CurrencyUid"] != null
      ? Currency(
          name: map.getString('${prefix}CurrencyName') ?? '', 
          uid: map.getString('${prefix}CurrencyUid') ?? ''
        ) 
      : null;
    return Account(
      name: map.getString('${prefix}AccountName') ?? '', 
      uid: map.getString('${prefix}AccountUid') ?? '', 
      currency: currency ?? Currency(uid: '', name: '')
    );
  }

  TransactionType _getOperationType(Map<String, Object?> map) {
    return TransactionType(
      name: map.getString('typeName') ?? '', 
      uid: map.getString('typeUid') ?? ''
    );
  }

  Expense _createExpense(Map<String, Object?> map) {
    return Expense(
      type: _getOperationType(map),
      account: _getAccount('from', map),
      amount: map.getMoney('fromAmount'),
      date: map.getDateTime('date')!,
      timestamp: map.getDateTime('timestamp')!,
      isPending: map.getBool('planned'),
      notes: map.getString('description') ?? '',
      uid: map.getString('uid') ?? '',
    );
  }

  Income _createIncome(Map<String, Object?> map) {
    return Income(
      type: _getOperationType(map),
      account: _getAccount('to', map),
      amount: map.getMoney('toAmount'),
      date: map.getDateTime('date')!,
      timestamp: map.getDateTime('timestamp')!,
      isPending: map.getBool('planned'),
      notes: map.getString('description') ?? '',
      uid: map.getString('uid') ?? '',
    );   
  }

  Transfer _createTransfer(Map<String, Object?> map) {
    return Transfer(
      fromAccount: _getAccount("from", map),
      fromAmount: map.getMoney('fromAmount'),
      toAccount: _getAccount("to", map),
      toAmount: map.getMoney('toAmount'),
      date: map.getDateTime('date')!,
      timestamp: map.getDateTime('timestamp')!,
      isPending: map.getBool('planned'),
      notes: map.getString('description') ?? '',
      uid: map.getString('uid') ?? '',
    );   
  }  

}