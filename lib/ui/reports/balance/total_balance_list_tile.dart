import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/money_date_info.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';

class TotalBalanceListTile extends StatelessWidget {

  final String name;
  final MoneyDateInfo enter;
  final MoneyDateInfo exit;

  const TotalBalanceListTile({super.key, required this.name, required this.enter, required this.exit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sign = exit.amount.amountInCents.compareTo(enter.amount.amountInCents);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: Text(name)),
          Text(exit.amount.formattedAmount, style: theme.textTheme.labelLarge),
          switch (sign) {
            1 => UiIcon(UiIcons.arrowDropUp, color: theme.colorScheme.primary),
            -1 => UiIcon(UiIcons.arrowDropDown, color: theme.colorScheme.error),
            _ => SizedBox(width: 24)
          }
        ],
      ),
    );
  }
  
}