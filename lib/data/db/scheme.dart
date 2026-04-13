class AccountsTable {
  static const String tableName = 'accounts';
  static const String uid = 'uid';
  static const String name = 'name';
  static const String currencyUid = 'currencyUid';
  static const String archived = 'archived';
  static const String position = 'position';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $uid TEXT NOT NULL,
      $name TEXT NOT NULL,
      $currencyUid TEXT,
      $archived INTEGER,
      $position INTEGER,
      PRIMARY KEY($uid)
    )
  ''';
}

class CurrenciesTable {
  static const String tableName = 'currencies';
  static const String uid = 'uid';
  static const String name = 'name';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $uid TEXT NOT NULL,
      $name TEXT NOT NULL,
      PRIMARY KEY($uid)
    )
  ''';
}

class ExpenseTypesTable {
  static const String tableName = 'expenseTypes';
  static const String uid = 'uid';
  static const String name = 'name';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $uid TEXT NOT NULL,
      $name TEXT NOT NULL,
      PRIMARY KEY($uid)
    )
  ''';
}

class ExpensesTable {
  static const String tableName = 'expenses';
  static const String uid = 'uid';
  static const String date = 'date';
  static const String timestamp = 'timestamp';
  static const String planned = 'planned';
  static const String typeUid = 'typeUid';
  static const String amount = 'amount';
  static const String accountUid = 'accountUid';
  static const String description = 'description';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $uid TEXT NOT NULL,
      $date INTEGER NOT NULL,
      $timestamp INTEGER,
      $planned INTEGER NOT NULL,
      $typeUid TEXT NOT NULL,
      $amount REAL NOT NULL,
      $accountUid TEXT NOT NULL,
      $description TEXT,
      PRIMARY KEY($uid)
    )
  ''';
}

class IncomeTypesTable {
  static const String tableName = 'incomeTypes';
  static const String uid = 'uid';
  static const String name = 'name';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $uid TEXT NOT NULL,
      $name TEXT NOT NULL,
      PRIMARY KEY($uid)
    )
  ''';
}

class IncomesTable {
  static const String tableName = 'incomes';
  static const String uid = 'uid';
  static const String date = 'date';
  static const String timestamp = 'timestamp';
  static const String planned = 'planned';
  static const String typeUid = 'typeUid';
  static const String amount = 'amount';
  static const String accountUid = 'accountUid';
  static const String description = 'description';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $uid TEXT NOT NULL,
      $date INTEGER NOT NULL,
      $timestamp INTEGER,
      $planned INTEGER NOT NULL,
      $typeUid TEXT NOT NULL,
      $amount REAL NOT NULL,
      $accountUid TEXT NOT NULL,
      $description TEXT,
      PRIMARY KEY($uid)
    )
  ''';
}

class MainFilterTable {
  static const String tableName = 'mainFilter';
  static const String id = 'id';
  static const String startDate = 'startDate';
  static const String endDate = 'endDate';
  static const String plannedInclude = 'plannedInclude';
  static const String text = 'text';
  static const String accountUid = 'accountUid';
  static const String incomeTypeUid = 'incomeTypeUid';
  static const String expenseTypeUid = 'expenseTypeUid';
  static const String tag = 'tag';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $id INTEGER NOT NULL,
      $startDate INTEGER,
      $endDate INTEGER,
      $plannedInclude INTEGER NOT NULL,
      $text TEXT,
      $accountUid TEXT,
      $incomeTypeUid TEXT,
      $expenseTypeUid TEXT,
      $tag TEXT,
      PRIMARY KEY($id)
    )
  ''';
}

class TagsTable {
  static const String tableName = 'tags';
  static const String name = 'name';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $name TEXT NOT NULL PRIMARY KEY
    )
  ''';
}

class TransfersTable {
  static const String tableName = 'transfers';
  static const String uid = 'uid';
  static const String date = 'date';
  static const String timestamp = 'timestamp';
  static const String planned = 'planned';
  static const String fromAmount = 'fromAmount';
  static const String toAmount = 'toAmount';
  static const String fromAccountUid = 'fromAccountUid';
  static const String toAccountUid = 'toAccountUid';
  static const String description = 'description';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $uid TEXT NOT NULL,
      $date INTEGER NOT NULL,
      $timestamp INTEGER,
      $planned INTEGER NOT NULL,
      $fromAmount REAL NOT NULL,
      $toAmount REAL NOT NULL,
      $fromAccountUid TEXT NOT NULL,
      $toAccountUid TEXT NOT NULL,
      $description TEXT,
      PRIMARY KEY($uid)
    )
  ''';
}

class BudgetTable {
  static const String tableName = 'budget';
  static const String uid = 'uid';
  static const String name = 'name';
  static const String amount = 'amount';
  static const String currencyUid = 'currencyUid';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $uid TEXT NOT NULL,
      $name TEXT NOT NULL,
      $amount REAL NOT NULL,
      $currencyUid TEXT NOT NULL,
      PRIMARY KEY($uid)
    )
  ''';
}

class BudgetLinkTable {
  static const String tableName = 'budgetLink';
  static const String budgetUid = 'budgetUid';
  static const String expenseTypeUid = 'expenseTypeUid';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $budgetUid TEXT NOT NULL,
      $expenseTypeUid TEXT NOT NULL
    )
  ''';
}