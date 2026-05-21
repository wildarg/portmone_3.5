import 'package:portmone_bloc/model/money.dart';

class NamedAmount {
  final String name;
  final Money amount;

  NamedAmount(this.amount, this.name);

  @override
  String toString() {
    return '{amount: $amount, name: $name}';
  }
}
