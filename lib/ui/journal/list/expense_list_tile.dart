import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;

  const ExpenseListTile({super.key, required this.expense, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final avatarTextColor = expense.isPending? context.colorScheme.error : theme.colorScheme.onSecondaryContainer;
    final titleColor = expense.isPending? context.colorScheme.error : theme.colorScheme.onSurface;
    final mainAmountColor = expense.isPending? context.colorScheme.error : theme.colorScheme.onSurface.withAlpha(200);
    final centsAmountColor = expense.isPending? context.colorScheme.error : theme.colorScheme.onSurfaceVariant;

    final notes = expense.notes.isNotEmpty
      ? Text(expense.notes) 
      : null;
    final (main, cents) = expense.amount.formattedSplitAmount;

    return ListTile(
      contentPadding: notes == null ? const EdgeInsets.symmetric(vertical: 8, horizontal: 16) : null,
      tileColor: theme.colorScheme.surfaceContainer,
      leading: CircleAvatar(
        backgroundColor: expense.type.name.toColor,
        child: Text(expense.type.name.substring(0, 1), style: context.textTheme.bodyMedium?.copyWith(color: avatarTextColor)),
      ),
      title: Text(expense.type.name, style: theme.textTheme.bodyMedium?.copyWith(color: titleColor)),
      subtitle: notes,
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('-$main', style: theme.textTheme.headlineSmall?.copyWith(
                color: mainAmountColor
              )),
              const SizedBox(width: 2),
              Text(cents, style: theme.textTheme.labelLarge?.copyWith(color: centsAmountColor)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(expense.account.name, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(width: 4),
              Text(expense.account.currency.name, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary))
            ],
          )
        ],
      ),   
      onTap: onTap,
    );
  }
}
