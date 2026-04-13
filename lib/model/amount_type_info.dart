import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/model/named_amount.dart';
import 'package:portmone_bloc/model/operation_type.dart';

class AmountTypeInfo {
  final TransactionType type;
  final Currency currency;
  final Money totalSpent;
  final Iterable<NamedAmount> chartData;

  AmountTypeInfo({
    required this.type, 
    required this.currency, 
    required this.totalSpent,
    this.chartData = const []
  });

  int get trendingSign {
    if (chartData.isEmpty) return 0;
    final hasData = chartData.length > 1 && chartData.take(chartData.length - 1).any((e) => e.amount.amountInCents != 0);
    if (!hasData) return 0;
    return chartData.last.amount.amountInCents
      .compareTo(chartData.toList()[chartData.length - 2].amount.amountInCents);
  }
}