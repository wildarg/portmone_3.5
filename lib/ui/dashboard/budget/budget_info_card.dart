import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/model/budget_info.dart';
import 'package:portmone_bloc/ui/core/ui_card.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class BudgetInfoCard extends StatelessWidget {

  final BudgetInfo info;

  const BudgetInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final spentAmount = info.spent.amountInCents;
    final budgetAmount = info.budget.amount.amountInCents;
    final double percent = budgetAmount > 0 ? (spentAmount / budgetAmount) : 0.0;
    final int percentInt = (percent * 100).toInt();
    final (mainPart, cents) = info.spent.formattedSplitAmount;
    final isOverspent = percent > 1.0;
    final progressColor = isOverspent ? context.colorScheme.error : info.budget.name.toColor;

    return UiCard(
      width: 220,
      height: 130,
      strokeWidth: isOverspent ? 1.0 : 0.5,
      strokeColor: isOverspent ? context.colorScheme.errorContainer : null,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: context.colorScheme.surfaceContainer,
      mainAxisAlignment: MainAxisAlignment.center,
      padding: const EdgeInsets.all(16),
      onTap: () {
        context.push('/budget/editor', extra: info.budget);
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  info.budget.name,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16),
                Text(
                  info.budget.currency.name,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(mainPart, style: context.textTheme.headlineSmall),
                    Text(cents, style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant
                    ))
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 54,
                height: 54,
                child: CircularProgressIndicator(
                  value: percent.clamp(0.0, 1.0),
                  backgroundColor: context.colorScheme.surfaceContainerHigh,
                  color: progressColor,
                  strokeWidth: 6,
                ),
              ),
              Text(
                '$percentInt%',
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
}