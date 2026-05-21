import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';

class AppBarContent extends StatelessWidget {
  const AppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('portmone', style: textTheme.titleLarge),
            StoreBuilder(
              stream: (store) => store.filterState,
              builder: (context, state) =>
                  Text(_filterToText(state), style: textTheme.labelSmall),
            ),
          ],
        ),
      ],
    );
  }

  String _filterToText(MainFilter filter) {
    return [
      if (filter.startDate.hasData)
        'from ${filter.startDate.value?.shortFormat}',
      if (filter.endDate.hasData) 'till ${filter.endDate.value?.shortFormat}',
      if (filter.plannedInclude) 'pending included',
      if (!filter.plannedInclude) 'no pending included',
    ].join(', ');
  }
}
