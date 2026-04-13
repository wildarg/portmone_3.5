import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/library_queries.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class CurrenciesRepo {
  
  final PortmoneDB db;

  CurrenciesRepo({required this.db});

  Future<Iterable<Currency>> getAll() {
    return GetAllCurrenciesQuery(db).execute();
  }

  Future<Currency> getOrSave(String name) async {
    final rows = await db.query("select * from ${CurrenciesTable.tableName} where ${CurrenciesTable.name} = '$name'");
    if (rows.isNotEmpty) return fromMap(rows[0]);
    final currency = Currency(
      uid: db.getNewUid(), 
      name: name
    );
    await db.insert(CurrenciesTable.tableName, toMap(currency));
    return currency;
  }

  Currency fromMap(Map<String, Object?> data) {
    return Currency(
      uid: data.getString(CurrenciesTable.uid) ?? '', 
      name: data.getString(CurrenciesTable.name) ?? ''
    );
  }

  Map<String, Object?> toMap(Currency currency) {
    return {
      CurrenciesTable.uid : currency.uid,
      CurrenciesTable.name : currency.name
    };
  }

}
