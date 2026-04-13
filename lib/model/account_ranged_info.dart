import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/money_date_info.dart';

class AccountRangedInfo {
  
  final Account account;
  final MoneyDateInfo enter;
  final MoneyDateInfo exit;

  AccountRangedInfo({required this.account, required this.enter, required this.exit});

  double get changePercent {
    final start = enter.amount.amountInCents;
    final end = exit.amount.amountInCents;

    if (start == 0) return 0;
    return (end - start) / start;
  }

  int get direction {
    final start = enter.amount.amountInCents;
    final end = exit.amount.amountInCents;
    return end.compareTo(start);
  }

  @override
  String toString() {
    return '{account: $account, enter: $enter, exit: $exit}';
  }

}