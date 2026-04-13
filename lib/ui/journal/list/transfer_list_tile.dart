import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';

class TransferListTile extends StatelessWidget {
  final Transfer transfer;
  
  const TransferListTile({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (mainFrom, centsFrom) = transfer.fromAmount.formattedSplitAmount;
    final (mainTo, centsTo) = transfer.toAmount.formattedSplitAmount;
    return ListTile(
      tileColor: theme.colorScheme.surfaceContainer,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(Icons.swap_horiz_outlined, color: theme.colorScheme.onSecondaryContainer)
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mainFrom, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurface.withAlpha(200))),
                    const SizedBox(width: 2),
                    Text(centsFrom, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: transfer.fromAccount.name,
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)
                      ),
                      TextSpan(
                        text: ' ${transfer.fromAccount.currency.name}',
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)
                      ),
                    ]
                  ),
                ),
              ],
            ),   
          ),
          Icon(Icons.keyboard_double_arrow_right, color: theme.colorScheme.secondary),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mainTo, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurface.withAlpha(200))),
                    const SizedBox(width: 2),
                    Text(centsTo, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: transfer.toAccount.name,
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)
                      ),
                      TextSpan(
                        text: ' ${transfer.toAccount.currency.name}',
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)
                      ),
                    ]
                  ),
                ),
              ],
            ),   
          ),
        ],
      ),
      subtitle: transfer.notes.isNotEmpty ? Text(transfer.notes) : null,
      onTap: () { },
    );
  }
}
