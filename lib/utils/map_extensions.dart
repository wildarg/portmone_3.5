// import 'package:ai_demo/domain/entities/money.dart';
// import 'package:ai_demo/domain/entities/operation_type.dart';

import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/model/operation_type.dart';

extension MapExtensions on Map<String, dynamic> {

  int? getInt(String name, {int? fallback}) {
    return (this[name] as num?)?.toInt() ?? fallback;
  }

  String? getString(String name, {String? fallback}) {
    return this[name] as String? ?? fallback;
  }

  Money getMoney(String name, {int fallback = 0}) {
    return Money(amountInCents: getInt(name) ?? fallback);
  }

  Currency getCurrency([String prefix = 'currency']) {
    final uid = getString('${prefix}Uid');
    final name = getString('${prefix}Name');
    if (uid == null) return Currency.empty;
    return Currency(uid: uid, name: name ?? '-');
  }

  Account getAccount([String prefix = 'account', String currecyPrefix = 'currency']) {
    final uid = getString('${prefix}Uid')!;
    final name = getString('${prefix}Name')!;
    return Account(uid: uid, name: name, currency: getCurrency(currecyPrefix));
  }

  Account? optAccount([String prefix = 'account', String currecyPrefix = 'currency']) {
    final uid = getString('${prefix}Uid');
    if (uid == null) return null;
    final name = getString('${prefix}Name')!;
    return Account(uid: uid, name: name, currency: getCurrency(currecyPrefix));
  }


  TransactionType getTransactionType(String prefix) {
    final uid = getString('${prefix}Uid')!;
    final name = getString('${prefix}Name')!;
    return TransactionType(uid: uid, name: name);
  }

  TransactionType? optTransactionType(String prefix) {
    final uid = getString('${prefix}Uid');
    if (uid == null) return null;
    final name = getString('${prefix}Name')!;
    return TransactionType(uid: uid, name: name);
  }

  DateTime? getDateTime(String name) {
    final millis = getInt(name);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  bool getBool(String name) {
    return getInt(name) == 1;
  }

}