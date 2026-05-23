import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/reports/accounts/account_balance_swimlane.dart';
import 'package:portmone_bloc/ui/reports/balance/balance_card.dart';
import 'package:portmone_bloc/ui/reports/expenses/expense_report_card.dart';
import 'package:portmone_bloc/ui/reports/incomes/income_report_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList.list(
          children: [
            BalanceCard(),
            AccountBalanceSwimlane(),
            ExpensesCard(),
            IncomesCard(),
          ],
        ),
      ],
    );
  }
}
