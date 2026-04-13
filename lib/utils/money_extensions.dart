import 'package:intl/intl.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

extension MoneyExtensions on Money {

  String get formattedAmount {
    final (main, cents) = formattedSplitAmount;
    return '$main$_decimalSeparator$cents';
  }

  (String, String) get formattedSplitAmount {
    final src = amountInCents.toString().padLeft(2, '0');
    int intPartLen = src.length - 2;
    int intPart = intPartLen > 0
      ? (int.tryParse(src.substring(0, intPartLen)) ?? 0)
      : 0;
    int centPart = int.tryParse(src.substring(intPartLen)) ?? 0;
    return (
      _fmt.format(intPart),
      centPart.toString().padLeft(2, '0')
    );
  }

}

interface class Separator {
  static String get decimal => _decimalSeparator;
  static String get group => _groupSeparator;  
}


extension TextMoneyExtensions on String? {

  double get asDouble => this == null? 0.0 : _fmt.parse(this!).toDouble();

  int get parseToCents {
    if (this == null || this!.isNullOrBlank) return 0;
    List<String> parts = this!.split(_fmt.symbols.DECIMAL_SEP);
    String integerPart = parts[0];
    String fractionalPart = parts.length > 1? parts[1].padRight(2, "0").substring(0, 2) : "00";
    try {
      return _fmt.parse("$integerPart$fractionalPart").floor();
    } on FormatException {
      return 0;
    }
  }

}

extension NumMoneyExtensions on num {

  String get formattedMoney => _fmt.format(this);  

}

extension IntMoneyExtensions on int {

  (String, String) get asFormattedAmountPair {
    final String src = toString().padLeft(2, '0');
    int intPartLen = src.length - 2;
    int intPart = intPartLen > 0
      ? (int.tryParse(src.substring(0, intPartLen)) ?? 0)
      : 0;
    int centPart = int.tryParse(src.substring(intPartLen)) ?? 0;
    return (
      _fmt.format(intPart),
      centPart.toString().padLeft(2, '0')
    );
  }

  String get asFormattedAmount {
    final (String intPart, String centPart) = asFormattedAmountPair;
    return '$intPart$_decimalSeparator$centPart';
  }

}

final _fmt = NumberFormat();
String get _decimalSeparator => _fmt.symbols.DECIMAL_SEP;
String get _groupSeparator => _fmt.symbols.GROUP_SEP;