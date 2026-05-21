import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/library_queries.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class ExpenseTypesRepo {
  final PortmoneDB db;

  ExpenseTypesRepo({required this.db});

  Future<Iterable<TransactionType>> getAll() {
    return GetAllExpenseTypesQuery(db).execute();
  }

  Future<TransactionType> getOrSave(String name) async {
    final rows = await db.query(
      "select * from ${ExpenseTypesTable.tableName} where ${ExpenseTypesTable.name} = '$name'",
    );
    if (rows.isNotEmpty) return fromMap(rows[0]);
    final transactionType = TransactionType(uid: db.getNewUid(), name: name);
    await db.insert(ExpenseTypesTable.tableName, toMap(transactionType));
    return transactionType;
  }

  TransactionType fromMap(Map<String, Object?> data) {
    return TransactionType(
      uid: data.getString(ExpenseTypesTable.uid) ?? '',
      name: data.getString(ExpenseTypesTable.name) ?? '',
      isArchived: (data[ExpenseTypesTable.archived] as num?)?.toInt() == 1,
    );
  }

  Map<String, Object?> toMap(TransactionType transactioType) {
    return {
      ExpenseTypesTable.uid: transactioType.uid,
      ExpenseTypesTable.name: transactioType.name,
      ExpenseTypesTable.archived: transactioType.isArchived ? 1 : 0,
    };
  }

  Future<void> update(TransactionType type) async {
    await db.insert(ExpenseTypesTable.tableName, toMap(type));
  }
}
