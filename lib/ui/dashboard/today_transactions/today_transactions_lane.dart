import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/model/transaction.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/routes/routes.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/journal/list/expense_list_tile.dart';
import 'package:portmone_bloc/ui/journal/list/income_list_tile.dart';
import 'package:portmone_bloc/ui/journal/list/transfer_list_tile.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';

class TodayTransactionsLane extends StatelessWidget {

  const TodayTransactionsLane({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      stream: (store) => store.journalState,
      builder: (context, journal) {
        final today = DateTime.now().withoutTime;
        final todayGroup = journal
            .where((group) => group.dateTime == today)
            .toList();
        final transactions = todayGroup.isNotEmpty
            ? todayGroup.first.transactions
            : <Transaction>[];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Transactions today',
                  style: context.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              if (transactions.isEmpty)
                _EmptyState()
              else
                ...transactions.map<Widget>(
                  (operation) => switch (operation) {
                    Expense() => ExpenseListTile(
                      expense: operation,
                      onTap: () => _openEditor(context, operation, '/expense/editor'),
                    ),
                    Transfer() => TransferListTile(
                      transfer: operation,
                      onTap: () => _openEditor(context, operation, '/transfer/editor'),
                    ),
                    Income() => IncomeListTile(
                      income: operation,
                      onTap: () => _openEditor(context, operation, '/income/editor'),
                    ),
                    _ => const SizedBox.shrink(),
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _openEditor(BuildContext context, Transaction transaction, String route) async {
    dynamic result = await context.push(route, extra: transaction);
    while (result is CreateNewTransaction) {
      if (!context.mounted) break;
      result = await context.push(route);
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/no_records.svg',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 12),
            Text(
              'No transactions yet',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
