import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

extension StringBufferSQLExtensions on StringBuffer {
  void addStartDate(String field, final DateTime? startDate) {
    if (startDate != null) {
      write(' and $field >= ${startDate.millisecondsSinceEpoch}');
    }
  }

  static const int _dayInMs = 86400000;

  void addEndDate(String field, final DateTime? endDate) {
    if (endDate != null) {
      write(
        ' and $field <= ${endDate.withoutTime.millisecondsSinceEpoch + _dayInMs - 1}',
      );
    }
  }

  void addPlanned(String field, bool isIncluded) {
    if (!isIncluded) {
      write(' and $field = 0');
    }
  }

  void addNoteFilter(String field, String? text) {
    if (!text.isNullOrBlank) {
      write(" and $field like '%$text%'");
    }
  }

  void addTextFilter(List<String> fields, String? text) {
    if (!text.isNullOrBlank) {
      String clause = fields.map((s) => "IFNULL($s, ' ')").join('||');
      write(" and $clause like '%$text%'");
    }
  }

  void addAccountSet(Account? account, List<String> fields) {
    if (account != null) {
      write(" and '${account.uid}' in (${fields.join(',')})");
    }
  }

  void addAccount(String field, Account? account) {
    if (account != null) {
      write(" and $field = '${account.uid}'");
    }
  }

  void addEntityUid(String field, String? uid) {
    if (uid != null) {
      write(" and $field = '$uid'");
    }
  }

  void takeUnless(bool condition) {
    if (condition) {
      write(' and 0 = 1');
    }
  }
}
