import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String get percFormatted {
    final text = _percFmt.format(this);
    return this > 0 ? '+$text' : text;
  }

  String get moneyFormatted {
    final text = _moneyFmt.format(this);
    return text;
  }
}

final _percFmt = NumberFormat(',##0.0#%');
final _moneyFmt = NumberFormat.compact();
