import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/dashboard/budget/budget_lane.dart';
import 'package:portmone_bloc/ui/dashboard/expense_tracker/expense_tracker.dart';
import 'package:portmone_bloc/ui/dashboard/quick_actions/quick_action_lane.dart';
import 'package:portmone_bloc/ui/dashboard/today_transactions/today_transactions_lane.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainer,
      child: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              ExpenseTracker(),
              QuickActionLane(),
              BudgetLane(),
              TodayTransactionsLane(),
            ],
          ),
        ],
      ),
    );
  }
}
