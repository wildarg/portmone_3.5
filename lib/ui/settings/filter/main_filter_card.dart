import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_card.dart';
import 'package:portmone_bloc/ui/core/ui_date_field.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/core/ui_switcher.dart';
import 'package:portmone_bloc/utils/nullable.dart';

class MainFilterCard extends StatelessWidget {
  const MainFilterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UiCard(
      title: 'Main filter',
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      child: StoreBuilder(
        stream: (store) => store.filterState,
        builder: (context, state) => Column(
          spacing: 8,
          children: [
            UiDateField(
              label: 'Start date',
              leadingIcon: UiIcon(UiIcons.dateRange),
              value: state.startDate.value,
              onChange: (value) => context.dispatch(
                UpdateMainFilterAction(
                  filter: state.copyWith(startDate: Nullable(value)),
                ),
              ),
            ),
            UiDateField(
              label: 'End date',
              leadingIcon: SizedBox(width: 24),
              value: state.endDate.value,
              onChange: (value) => context.dispatch(
                UpdateMainFilterAction(
                  filter: state.copyWith(endDate: Nullable(value)),
                ),
              ),
            ),
            UiSwitcher(
              label: 'Include pending',
              leading: UiIcon(UiIcons.pending),
              value: state.plannedInclude,
              onChanged: (value) => context.dispatch(
                UpdateMainFilterAction(
                  filter: state.copyWith(plannedInclude: value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
