import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/library_queries.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class IncomeTypesRepo {
  final PortmoneDB db;

  IncomeTypesRepo({required this.db});

  Future<Iterable<TransactionType>> getAll() {
    return GetAllIncomeTypesQuery(db).execute();
  }

  Future<TransactionType> getOrSave(String name) async {
    final rows = await db.query(
      "select * from ${IncomeTypesTable.tableName} where ${IncomeTypesTable.name} = '$name'",
    );
    if (rows.isNotEmpty) return fromMap(rows[0]);
    final transactionType = TransactionType(uid: db.getNewUid(), name: name);
    await db.insert(IncomeTypesTable.tableName, toMap(transactionType));
    return transactionType;
  }

  TransactionType fromMap(Map<String, Object?> data) {
    return TransactionType(
      uid: data.getString(IncomeTypesTable.uid) ?? '',
      name: data.getString(IncomeTypesTable.name) ?? '',
      isArchived: (data[IncomeTypesTable.archived] as num?)?.toInt() == 1,
    );
  }

  Map<String, Object?> toMap(TransactionType transactioType) {
    return {
      IncomeTypesTable.uid: transactioType.uid,
      IncomeTypesTable.name: transactioType.name,
      IncomeTypesTable.archived: transactioType.isArchived ? 1 : 0,
    };
  }

  Future<void> update(TransactionType type) async {
    await db.insert(IncomeTypesTable.tableName, toMap(type));
  }
}
