import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_card.dart';
import 'package:portmone_bloc/ui/reports/common/total_transaction_list_tile.dart';
import 'package:portmone_bloc/ui/reports/common/typed_transaction_sheet.dart';

class ExpensesCard extends StatelessWidget {
  const ExpensesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UiCard(
      title: 'Espense Report',
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TotalTransactionListTile(streamBuilder: (store) => store.totalExpenseState),
          TypedTransactionSheet(streamBuilder: (store) => store.typedExpenseState, isExpense: true)
        ],
      )
    );
  }
  
}