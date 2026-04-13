import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/account_ranged_info.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/utils/double_extensions.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';

class RangedAccountListTile extends StatelessWidget {

  final AccountRangedInfo info;
  final double? height;
  final double? width;
  final VoidCallback? onTap;

  const RangedAccountListTile({
    super.key, 
    required this.info,
    this.height,
    this.width,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (mainPart, cents) = info.exit.amount.formattedSplitAmount;
    Widget child = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(info.account.name)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 4,
                children: [
                  Text(info.account.currency.name, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(mainPart, style: theme.textTheme.headlineSmall),
                      Text(cents, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant))
                    ],
                  ),
                ],
              )
            ],
          ),
          if (info.direction != 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  info.changePercent.percFormatted, 
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: info.direction == 1
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error
                  )
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: info.direction == 1
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.errorContainer
                  ),
                  padding: const EdgeInsets.all(4),
                  child: UiIcon(
                    info.direction == 1
                      ? UiIcons.arrowUpward
                      : UiIcons.arrowDownward, 
                    color: info.direction == 1
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onErrorContainer
                  )
                )
              ],
            )
        ],
      ),
    );

    if (onTap != null) {
      child = InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: child,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Card(        
        elevation: 0,
        child: child,
      ),
    );
  }
  
}