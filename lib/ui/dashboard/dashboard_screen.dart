import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/dashboard/expense_tracker.dart/expense_tracker.dart';

class DashboardScreen extends StatelessWidget {
  
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              ExpenseTracker()
            ]
          )
        ],
    );
  }
  
}