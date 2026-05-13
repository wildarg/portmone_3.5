import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class ExpensesRepo {

  final PortmoneDB db;

  ExpensesRepo({required this.db});
  
  Future<void> save(Expense expense) async {
    await db.insert(ExpensesTable.tableName, toMap(expense));
  }

  Future<void> deleteByUid(String uid) async {
    await db.delete(ExpensesTable.tableName, where: '${ExpensesTable.uid} = ?', args: [uid]);
  }

  Map<String, Object?> toMap(Expense expense) {
    return {
      ExpensesTable.uid : expense.uid.isNullOrBlank? db.getNewUid() : expense.uid,
      ExpensesTable.date : expense.date.millisecondsSinceEpoch,
      ExpensesTable.timestamp : expense.timestamp.millisecondsSinceEpoch,
      ExpensesTable.planned : expense.isPending? 1 : 0,
      ExpensesTable.typeUid : expense.type.uid,
      ExpensesTable.amount : expense.amount.amountInCents,
      ExpensesTable.accountUid : expense.account.uid,
      ExpensesTable.description : expense.notes,
    };
  }
  
}