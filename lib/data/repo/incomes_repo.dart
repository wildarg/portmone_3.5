import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class IncomesRepo {

  final PortmoneDB db;

  IncomesRepo({required this.db});
  
  Future<void> save(Income income) async {
    await db.insert(IncomesTable.tableName, toMap(income));
  }

  Map<String, Object?> toMap(Income income) {
    return {
      IncomesTable.uid : income.uid.isNullOrBlank? db.getNewUid() : income.uid,
      IncomesTable.date : income.date.millisecondsSinceEpoch,
      IncomesTable.timestamp : income.timestamp.millisecondsSinceEpoch,
      IncomesTable.planned : income.isPending? 1 : 0,
      IncomesTable.typeUid : income.type.uid,
      IncomesTable.amount : income.amount.amountInCents,
      IncomesTable.accountUid : income.account.uid,
      IncomesTable.description : income.notes,
    };
  }
  
}
