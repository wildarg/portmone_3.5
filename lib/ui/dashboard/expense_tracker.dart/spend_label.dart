import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';

class SpendLabel extends StatelessWidget {

  final Money amount;
  final String label;

  const SpendLabel({
    super.key, 
    required this.amount,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    final (main, cents) = amount.formattedSplitAmount;
    final amountColor = amount.amountInCents == 0
      ? context.colorScheme.surfaceContainerHighest
      : context.colorScheme.onSurface;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(main, style: context.textTheme.displaySmall?.copyWith(color: amountColor)),
            Text(cents, style: context.textTheme.headlineSmall?.copyWith(color: amountColor)),
          ],
        ),
        Text(label, style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onSurfaceVariant))
      ],
    );
  }

}
