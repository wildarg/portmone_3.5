import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/ui/journal/list/transaction_notes.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';

class TransferListTile extends StatelessWidget {
  final Transfer transfer;
  final VoidCallback? onTap;
  
  const TransferListTile({super.key, required this.transfer, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final avatarIconColor = transfer.isPending? context.colorScheme.error : theme.colorScheme.onSecondaryContainer;
    final mainAmountColor = transfer.isPending? context.colorScheme.error : theme.colorScheme.onSurface.withAlpha(200);
    final centsAmountColor = transfer.isPending? context.colorScheme.error : theme.colorScheme.onSurfaceVariant;
    final transferIconColor = transfer.isPending? context.colorScheme.error : theme.colorScheme.secondary;


    final (mainFrom, centsFrom) = transfer.fromAmount.formattedSplitAmount;
    final (mainTo, centsTo) = transfer.toAmount.formattedSplitAmount;
    return ListTile(
      tileColor: theme.colorScheme.surfaceContainer,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(Icons.swap_horiz_outlined, color: avatarIconColor)
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
                    Text(mainFrom, style: theme.textTheme.titleLarge?.copyWith(color: mainAmountColor)),
                    const SizedBox(width: 2),
                    Text(centsFrom, style: theme.textTheme.labelLarge?.copyWith(color: centsAmountColor)),
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
          Icon(Icons.keyboard_double_arrow_right, color: transferIconColor),
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
                    Text(mainTo, style: theme.textTheme.titleLarge?.copyWith(color: mainAmountColor)),
                    const SizedBox(width: 2),
                    Text(centsTo, style: theme.textTheme.labelLarge?.copyWith(color: centsAmountColor)),
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
      subtitle: transfer.notes.isNotEmpty ? TransactionNotes(transfer.notes) : null,
      onTap: onTap,
    );
  }
}
