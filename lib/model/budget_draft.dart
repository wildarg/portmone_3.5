import 'package:portmone_bloc/model/budget.dart';

class BudgetDraft {
  final String? uid;
  final String? name;
  final int? amountInCents;
  final String? currencyName;
  final Set<String> expenseTypeUids;

  BudgetDraft({
    this.uid,
    this.name,
    this.amountInCents,
    this.currencyName,
    this.expenseTypeUids = const <String>{},
  });

  static BudgetDraft fromBudget(Budget src) {
    return BudgetDraft(
      uid: src.uid,
      name: src.name,
      amountInCents: src.amount.amountInCents,
      currencyName: src.currency.name,
      expenseTypeUids: src.expenseTypeUids.toSet(),
    );
  }

  BudgetDraft copyWith({
    String? uid,
    String? name,
    int? amountInCents,
    String? currencyName,
    Set<String>? expenseTypeUids,
  }) {
    return BudgetDraft(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      amountInCents: amountInCents ?? this.amountInCents,
      currencyName: currencyName ?? this.currencyName,
      expenseTypeUids: expenseTypeUids ?? this.expenseTypeUids,
    );
  }
}
