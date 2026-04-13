import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/get_journal_query.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/model/transaction.dart';

class JournalRepo {

  final PortmoneDB db;

  JournalRepo({required this.db});

  Future<Iterable<Transaction>> getJournal(MainFilter filter) {
    return GetJournalQuery(db).execute(filter);
  }
  
}