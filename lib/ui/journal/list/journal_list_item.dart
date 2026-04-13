import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/model/date_transactions.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/routes/routes.dart';
import 'package:portmone_bloc/ui/journal/list/expense_list_tile.dart';
import 'package:portmone_bloc/ui/journal/list/income_list_tile.dart';
import 'package:portmone_bloc/ui/journal/list/transfer_list_tile.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';

class JournalListItem extends StatelessWidget {

  final DateTransactions data;

  const JournalListItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: context.colorScheme.surfaceContainer,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(data.dateTime.shortFormat, style: context.textTheme.bodySmall),
            ],
          ),
        )
      ] + data.transactions.map<Widget>((operation) =>
        switch (operation) {
          Expense() => ExpenseListTile(expense: operation, onTap: () => _openExpenseEditor(context, operation)),
          Transfer() => TransferListTile(transfer: operation),
          Income() => IncomeListTile(income: operation),
          _ => Container()
        }
      ).toList(),
    );
  }

  void _openExpenseEditor(BuildContext context, Expense expense) async {
    dynamic result = await context.push('/expense/editor', extra: expense);
    while (result is CreateNewTransaction) {
      if (context.mounted) {
        result = await context.push('/expense/editor', extra: null);
      }
    }
  }
  
}