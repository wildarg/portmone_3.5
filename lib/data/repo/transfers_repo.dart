import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class TransfersRepo {

  final PortmoneDB db;

  TransfersRepo({required this.db});

  Future<void> save(Transfer transfer) async {
    await db.insert(TransfersTable.tableName, toMap(transfer));
  }

  Map<String, Object?> toMap(Transfer transfer) {
    return {
      TransfersTable.uid: transfer.uid.isNullOrBlank ? db.getNewUid() : transfer.uid,
      TransfersTable.date: transfer.date.millisecondsSinceEpoch,
      TransfersTable.timestamp: transfer.timestamp.millisecondsSinceEpoch,
      TransfersTable.planned: transfer.isPending ? 1 : 0,
      TransfersTable.fromAmount: transfer.fromAmount.amountInCents,
      TransfersTable.toAmount: transfer.toAmount.amountInCents,
      TransfersTable.fromAccountUid: transfer.fromAccount.uid,
      TransfersTable.toAccountUid: transfer.toAccount.uid,
      TransfersTable.description: transfer.notes,
    };
  }
}
