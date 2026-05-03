import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_scrollable_swimlane.dart';
import 'package:portmone_bloc/ui/dashboard/budget/budget_info_card.dart';
import 'package:portmone_bloc/ui/dashboard/budget/new_budget_card.dart';

class BudgetLane extends StatelessWidget {

  const BudgetLane({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      stream: (store) => store.budgetState,
      builder:(_, state) => UiScrollableSwimlane(
        title: 'Budget',
        height: 150,
        items: state.map<Widget>(
          (budgetInfo) => BudgetInfoCard(info: budgetInfo)
        ).toList() + <Widget>[NewBudgetCard()],
      ),
    );
  }
  
}