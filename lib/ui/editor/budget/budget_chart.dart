import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/model/money_date_info.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/date_utils.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';
import 'package:portmone_bloc/utils/list_extensions.dart';

class BudgetChart extends StatelessWidget {
  final List<MoneyDateInfo>? data;
  final Money limit;

  const BudgetChart({super.key, required this.data, required this.limit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: context.colorScheme.surface,
          height: 200,
          child: LineChart(
            _getBudgetChartData(context),
            duration: const Duration(milliseconds: 150),
          ),
        ),
      ),
    );
  }

  LineChartData _getBudgetChartData(BuildContext context) {
    double maxAmount =
        data?.map((e) => e.amount.asDouble).lastOrNull ?? limit.asDouble;
    DateTime? firstDate = data?.firstOrNull?.date;

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: firstDate != null,
            getTitlesWidget: (value, meta) {
              return Text(
                DateTimeUtils.toChartLabel(
                      firstDate!.addDays(value.toInt()),
                      Intl.defaultLocale,
                      showMonth: (value % 10) == 0,
                    ) ??
                    '',
                style: context.textTheme.labelSmall,
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        if (data != null && data!.isNotEmpty)
          _getBudgetLineChartBarData(context, data!),
        if (limit.amountInCents > 0) _budgetLine(context, limit.asDouble, data),
      ],
      backgroundColor: context.colorScheme.surface,
      maxY: _getMax(maxAmount, limit.asDouble)?.let((it) => it * 1.3),
      minY: 0.0,
    );
  }

  double? _getMax(double? one, double? other) {
    if (one == null) {
      return other;
    } else if (other == null) {
      return one;
    }
    return max(one, other);
  }

  LineChartBarData _getBudgetLineChartBarData(
    BuildContext context,
    Iterable<MoneyDateInfo> data,
  ) {
    return LineChartBarData(
      isCurved: true,
      preventCurveOverShooting: true,
      color: context.colorScheme.secondary,
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.colorScheme.secondary.withAlpha(100),
            context.colorScheme.secondaryContainer.withAlpha(100),
          ],
        ),
      ),
      spots: data.mapIndexed(_toSpot).toList(),
    );
  }

  LineChartBarData _budgetLine(
    BuildContext context,
    double amount,
    Iterable<MoneyDateInfo>? data,
  ) {
    List<DateTime>? timeline = data?.map((e) => e.date).toList();
    double start = 0;
    double end =
        timeline?.let(
          (it) => it.lastOrNull?.difference(it.first).inDays.toDouble(),
        ) ??
        30;
    return LineChartBarData(
      isCurved: false,
      color: context.colorScheme.tertiary,
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      spots: [FlSpot(start, amount), FlSpot(end, amount)],
      dashArray: [8, 4],
    );
  }

  FlSpot _toSpot(int ind, MoneyDateInfo e) {
    return FlSpot(ind.toDouble(), e.amount.asDouble);
  }
}
