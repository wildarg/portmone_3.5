import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/library_queries.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class AccountsRepo {

  final PortmoneDB db;

  AccountsRepo({required this.db});
  
  Future<Iterable<Account>> getAll() {
    return GetAllAccountsQuery(db).execute(includeArchived: true);
  }

  Future<void> save(Account account) async {
    await db.insert(AccountsTable.tableName, account.toMap());
  }

  Future<void> updatePosition(List<Account> ordered) async {
    final temp = ordered.indexed.map(_toSQL).join(' union all ');
    await db.exec([
      '''
      WITH ordered AS ($temp)
      UPDATE accounts
      SET position = (
        SELECT new_pos FROM ordered WHERE ordered.uid = accounts.uid
      )
      '''
    ]);
  }

  Future<Account> getOrSave(String name, Currency currency) async {
    final sql = """
      select
        a.*,
        c.${CurrenciesTable.name} as currencyName
      from
        ${AccountsTable.tableName} a
        join ${CurrenciesTable.tableName} c on c.${CurrenciesTable.uid} = a.${AccountsTable.currencyUid}
      where
        a.${AccountsTable.name} = '$name'
        and c.${CurrenciesTable.name} = '${currency.name}'
    """;
    final rows = await db.query(sql);
    if (rows.isNotEmpty) return fromMap(rows[0]);

    final account = Account(
      uid: db.getNewUid(), 
      name: name, 
      currency: currency
    );

    await db.insert(AccountsTable.tableName, toMap(account));
    return account;
  }

  String _toSQL((int, Account) data) {
    return "select ${data.$1} as new_pos, '${data.$2.uid}' as uid";
  }

  Account fromMap(Map<String, Object?> data) {
    final currency = Currency(
      uid: data.getString(AccountsTable.currencyUid) ?? '', 
      name: data.getString('currencyName') ?? ''
    );
    return Account(
      uid: data.getString(AccountsTable.uid) ?? '', 
      name: data.getString(AccountsTable.name) ?? '', 
      currency: currency
    );
  }

  Map<String, Object?> toMap(Account account) {
    return {
      AccountsTable.uid : account.uid,
      AccountsTable.name : account.name,
      AccountsTable.currencyUid : account.currency.uid,
      AccountsTable.archived : account.isArchived? 1 : 0
    };
  }
  
}

extension _AccountExtensions on Account {

  Map<String, dynamic> toMap() => {
    AccountsTable.uid : uid,
    AccountsTable.name : name,
    AccountsTable.currencyUid : currency.uid,
    AccountsTable.archived : isArchived? 1 : 0,
  };

}