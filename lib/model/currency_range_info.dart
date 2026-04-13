import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/money_date_info.dart';

class CurrencyRangeInfo {

    final Currency currency;
    final MoneyDateInfo enter;
    final MoneyDateInfo exit;

  CurrencyRangeInfo({
    required this.currency, 
    required this.enter, 
    required this.exit
  });

}