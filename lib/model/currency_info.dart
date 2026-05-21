import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/money.dart';

class CurrencyInfo {
  final Currency currency;
  final Money amount;
  CurrencyInfo({required this.currency, required this.amount});
}
