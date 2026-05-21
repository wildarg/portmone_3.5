import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_scrollable_swimlane.dart';
import 'package:portmone_bloc/ui/dashboard/budget/budget_info_card.dart';
import 'package:portmone_bloc/ui/dashboard/budget/new_budget_card.dart';
import 'package:portmone_bloc/utils/date_utils.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';

class BudgetLane extends StatelessWidget {
  const BudgetLane({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      stream: (store) => store.budgetState,
      builder: (_, state) {
        final filter = context.store.filterState.value;
        final (startDate, endDate) = DateTimeUtils.getBudgetInterval(
          filter.startDate.value,
          filter.endDate.value,
        );
        final title =
            'Budget ${startDate.shortFormat} - ${endDate.shortFormat}';
        return UiScrollableSwimlane(
          title: title,
          height: 130,
          items:
              state
                  .map<Widget>((budgetInfo) => BudgetInfoCard(info: budgetInfo))
                  .toList() +
              <Widget>[NewBudgetCard()],
        );
      },
    );
  }
}
