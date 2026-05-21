import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/amount_type_info.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/reports/common/month_amount_chart.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';

class TypeAmountListTile extends StatefulWidget {

  final AmountTypeInfo data;
  final bool isExpense;

  const TypeAmountListTile({super.key, required this.data, required this.isExpense});

  @override
  State<TypeAmountListTile> createState() => _TypeAmountListTileState();
}

class _TypeAmountListTileState extends State<TypeAmountListTile> {

  bool _collapsed = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() {
        _collapsed = !_collapsed;
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: Text(widget.data.type.name)),
                if (widget.isExpense && widget.data.trendingSign == 1)
                  UiIcon(UiIcons.trendingUp, color: theme.colorScheme.error),
                if (widget.isExpense && widget.data.trendingSign == -1)
                  UiIcon(UiIcons.trendingDown, color: theme.colorScheme.primary),
                if (!widget.isExpense && widget.data.trendingSign == 1)
                  UiIcon(UiIcons.trendingUp, color: theme.colorScheme.primary),
                if (!widget.isExpense && widget.data.trendingSign == -1)
                  UiIcon(UiIcons.trendingDown, color: theme.colorScheme.error),
                const SizedBox(width: 4.0),
                Text(widget.data.currency.name, style: TextStyle(color: theme.colorScheme.primary)),
                const SizedBox(width: 4.0),
                Text(widget.data.totalSpent.formattedAmount, style: theme.textTheme.labelLarge),
                UiIcon(UiIcons.arrowDropDown, color: theme.colorScheme.outline)
              ],
            ),
            if (!_collapsed) const SizedBox(height: 24),
            if (!_collapsed) SizedBox(
              height: 200,
              child: MonthAmountChart(data: widget.data.chartData)
            ),
            if (!_collapsed) const SizedBox(height: 16),
            if (!_collapsed) UiButton.secondary(
              icon: UiIcons.filter,
              text: 'Filter by ${widget.data.type.name}',
              onTap: () {
                context.dispatch(SetTransactionTypeFilterAction(widget.data.type));
              },
            ),
          ],
        ),
      ),
    );
  }
}