import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/journal/list/dismissable_background.dart';
import 'package:portmone_bloc/ui/journal/list/dismissible_helper.dart';
import 'package:portmone_bloc/ui/journal/list/transaction_notes.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';

class IncomeListTile extends StatelessWidget {
  final Income income;
  final VoidCallback? onTap;

  const IncomeListTile({super.key, required this.income, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final avatarTextColor = income.isPending
        ? context.colorScheme.error
        : theme.colorScheme.onPrimaryContainer;
    final titleColor = income.isPending
        ? context.colorScheme.error
        : theme.colorScheme.onSurface;
    final mainAmountColor = income.isPending
        ? context.colorScheme.error
        : theme.colorScheme.onSurface.withAlpha(200);
    final centsAmountColor = income.isPending
        ? context.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;

    final (main, cents) = income.amount.formattedSplitAmount;

    return Dismissible(
      key: ValueKey(income.uid),
      background: const DismissableBackground(),
      onDismissed: (_) => DismissibleHelper.onDismiss(context, income),
      child: ListTile(
        tileColor: theme.colorScheme.surfaceContainer,
        leading: CircleAvatar(
          child: UiIcon(UiIcons.wallet2, color: avatarTextColor),
        ),
        title: Text(
          income.type.name,
          style: theme.textTheme.bodyMedium?.copyWith(color: titleColor),
        ),
        subtitle: income.notes.isNotEmpty
            ? TransactionNotes(income.notes)
            : null,
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  main,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: mainAmountColor,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  cents,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: centsAmountColor,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  income.account.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  income.account.currency.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
