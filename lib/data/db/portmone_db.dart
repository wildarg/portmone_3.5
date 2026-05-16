import 'package:portmone_bloc/data/db/db_helper.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class PortmoneDB extends DBHelper {

  @override
  List<String> get scheme => [
    AccountsTable.createTableSql,
    CurrenciesTable.createTableSql,
    ExpenseTypesTable.createTableSql,
    ExpensesTable.createTableSql,
    IncomeTypesTable.createTableSql,
    IncomesTable.createTableSql,
    MainFilterTable.createTableSql,
    TagsTable.createTableSql,
    TransfersTable.createTableSql,
    BudgetTable.createTableSql,
    BudgetLinkTable.createTableSql,
  ];

  @override
  Map<int, Future<void> Function(Database db)> get upgradeMap => {
    20: _upgradeTo20,
    21: _upgradeTo21,
    22: _upgradeTo22,
    25: _upgradeTo25,
    26: _upgradeTo26,
    27: _upgradeTo27,
  };

  PortmoneDB() : super(name: 'portmone', version: 27);

  Future<void> _upgradeTo20(Database db) async {
      List<Map<String, dynamic>> values = await db.query('mainFilter', where: 'id = ?', whereArgs: [0]);
      await db.exec([
        'drop table if exists mainFilter',
        MainFilterTable.createTableSql
      ]);
      if (values.isNotEmpty) {
        await db.insert(MainFilterTable.tableName, values.first);
      }
  }

  Future<void> _upgradeTo21(Database db) {
    return db.exec([
        'alter table expenses add timestamp integer',
        'alter table incomes add timestamp integer',
        'alter table transfers add timestamp integer',
        'update expenses set timestamp = date',
        'update incomes set timestamp = date',
        'update transfers set timestamp = date',
    ]);
  }

  Future<void> _upgradeTo22(Database db) {
    return db.exec([
      BudgetTable.createTableSql,
      BudgetLinkTable.createTableSql
    ]);
  }

  Future<void> _upgradeTo25(Database db) {
    return db.exec([
      'alter table accounts add archived integer',
    ]);
  }

  Future<void> _upgradeTo26(Database db) {
    return db.exec([
      'alter table accounts add position integer',
      '''
      WITH ordered AS (
        SELECT uid,
              ROW_NUMBER() OVER (ORDER BY name) - 1 AS new_pos
        FROM accounts
      )
      UPDATE accounts
      SET position = (
        SELECT new_pos FROM ordered WHERE ordered.uid = accounts.uid
      )
      '''
    ]);
  }

  Future<void> _upgradeTo27(Database db) {
    return db.exec([
      'alter table expenseTypes add archived integer',
      'alter table incomeTypes add archived integer',
    ]);
  }

  String getNewUid() {
    return const Uuid().v1();
  }


}