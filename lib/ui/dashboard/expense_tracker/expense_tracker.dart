import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/dashboard/expense_tracker/expense_tracker_content.dart';

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      stream: (store) => store.expenseTrackerState,
      builder: (context, state) => ExpenseTrackerContent(data: state),
    );
  }
}
