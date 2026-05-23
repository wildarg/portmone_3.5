import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/operation_type.dart';

class GetAllCurrenciesQuery {
  final PortmoneDB portmoneDB;

  GetAllCurrenciesQuery(this.portmoneDB);

  Future<Iterable<Currency>> execute() async {
    const sql = 'SELECT * FROM ${CurrenciesTable.tableName}';
    final records = await portmoneDB.query(sql);
    return records.map(_toCurrency);
  }

  Currency _toCurrency(Map<String, Object?> map) {
    return Currency(
      uid: map[CurrenciesTable.uid] as String,
      name: map[CurrenciesTable.name] as String,
    );
  }
}

class GetAllAccountsQuery {
  final PortmoneDB portmoneDB;

  GetAllAccountsQuery(this.portmoneDB);

  String _getSql(bool includeArchived) =>
      '''
      select 
        a.*, 
        c.name as currencyName
      from 
        ${AccountsTable.tableName} a 
        left join ${CurrenciesTable.tableName} c on c.${CurrenciesTable.uid} = a.${AccountsTable.currencyUid}
      where
        coalesce(a.${AccountsTable.archived}, 0) <= ${includeArchived ? 1 : 0}
      order by a.${AccountsTable.name}, c.${CurrenciesTable.name}
  ''';

  Future<Iterable<Account>> execute({bool includeArchived = false}) async {
    final sql = _getSql(includeArchived);
    final records = await portmoneDB.query(sql);
    return records.map(_toAccount);
  }

  Account _toAccount(Map<String, Object?> map) {
    final currencyUid = map[AccountsTable.currencyUid] as String?;
    final currency = currencyUid != null
        ? Currency(
            name: (map['currencyName'] as String?) ?? 'NO NAME',
            uid: map[AccountsTable.currencyUid] as String,
          )
        : null;

    return Account(
      uid: map[AccountsTable.uid] as String,
      name: map[AccountsTable.name] as String,
      currency: currency ?? Currency(uid: '', name: ''),
      isArchived: (map[AccountsTable.archived] as num?)?.toInt() == 1,
    );
  }
}

class GetAllExpenseTypesQuery {
  final PortmoneDB portmoneDB;

  GetAllExpenseTypesQuery(this.portmoneDB);

  Future<Iterable<TransactionType>> execute() async {
    const sql =
        'SELECT * FROM ${ExpenseTypesTable.tableName} order by ${ExpenseTypesTable.name}';
    final records = await portmoneDB.query(sql);
    return records.map(_toOperationType);
  }

  TransactionType _toOperationType(Map<String, Object?> map) {
    return TransactionType(
      uid: map[ExpenseTypesTable.uid] as String,
      name: map[ExpenseTypesTable.name] as String,
      isArchived: (map[ExpenseTypesTable.archived] as num?)?.toInt() == 1,
    );
  }
}

class GetAllIncomeTypesQuery {
  final PortmoneDB portmoneDB;

  GetAllIncomeTypesQuery(this.portmoneDB);

  Future<Iterable<TransactionType>> execute() async {
    const sql =
        'SELECT * FROM ${IncomeTypesTable.tableName} order by ${IncomeTypesTable.name}';
    final records = await portmoneDB.query(sql);
    return records.map(_toOperationType);
  }

  TransactionType _toOperationType(Map<String, dynamic> map) {
    return TransactionType(
      uid: map[IncomeTypesTable.uid] as String,
      name: map[IncomeTypesTable.name] as String,
      isArchived: (map[IncomeTypesTable.archived] as num?)?.toInt() == 1,
    );
  }
}

class GetAllTagsQuery {
  final PortmoneDB portmoneDB;

  GetAllTagsQuery(this.portmoneDB);

  Future<Iterable<String>> execute() async {
    const sql = 'SELECT * FROM ${TagsTable.tableName}';
    final records = await portmoneDB.query(sql);
    return records.map((map) => map[TagsTable.name] as String);
  }
}
