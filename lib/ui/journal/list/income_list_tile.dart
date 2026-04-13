import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';

class IncomeListTile extends StatelessWidget {
  final Income income;
  
  const IncomeListTile({super.key, required this.income});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (main, cents) = income.amount.formattedSplitAmount;
    
    return ListTile(
      tileColor: theme.colorScheme.surfaceContainer,
      leading: const CircleAvatar(
        child: UiIcon(UiIcons.wallet2),
      ),
      title: Text(income.type.name, style: theme.textTheme.bodyMedium),
      subtitle: income.notes.isNotEmpty ? Text(income.notes, style: theme.textTheme.bodySmall) : null,
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(main, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface.withAlpha(200))),
              const SizedBox(width: 2),
              Text(cents, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(income.account.name, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(width: 4),
              Text(income.account.currency.name, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary))
            ],
          )
        ],
      ),   
      onTap: () {},
    );
  }
}
