import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/named_amount.dart';
import 'package:portmone_bloc/utils/double_extensions.dart';
import 'package:portmone_bloc/utils/list_extensions.dart';

class MonthAmountChart extends StatelessWidget {
  final Iterable<NamedAmount> data;

  const MonthAmountChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxY = data
        .map((e) => e.amount.asDouble)
        .fold<double>(0, (old, next) => max(old, next));
    final chartMaxY = maxY == 0 ? 10.0 : maxY;
    final labels = data.map((e) => e.name).toList();
    final theme = Theme.of(context);

    return BarChart(
      BarChartData(
        maxY: chartMaxY,
        minY: 0.0,
        gridData: FlGridData(drawVerticalLine: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => theme.colorScheme.surfaceDim,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 60,
              showTitles: true,
              getTitlesWidget: (value, _) =>
                  Text(value.moneyFormatted, style: theme.textTheme.bodySmall),
              maxIncluded: false,
            ),
          ),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text(labels[value.toInt()]),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data
            .mapIndexed((ind, e) => _toBar(ind, e, chartMaxY, theme))
            .toList(),
      ),
    );
  }

  BarChartGroupData _toBar(
    int ind,
    NamedAmount tracker,
    double maxY,
    ThemeData theme,
  ) {
    return BarChartGroupData(
      x: ind,

      barRods: [
        BarChartRodData(
          toY: tracker.amount.asDouble,
          color: theme.colorScheme.secondary.withAlpha(100),
          width: 30,
          backDrawRodData: BackgroundBarChartRodData(
            toY: maxY,
            color: theme.colorScheme.onSurface.withAlpha(10),
            show: true,
          ),
        ),
      ],
    );
  }
}
