import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/amount_tracker_info.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/ui/dashboard/expense_tracker/animated_spend_label.dart';
import 'package:portmone_bloc/ui/dashboard/expense_tracker/currency_selector.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class TotalAmountWidget extends StatefulWidget {
  final List<AmountTrackerData> data;
  final VoidCallback? onClose;

  const TotalAmountWidget({super.key, this.data = const [], this.onClose});

  @override
  State<StatefulWidget> createState() => _TotalAmountWidgetState();
}

class _TotalAmountWidgetState extends State<TotalAmountWidget> {
  int _selected = 0;
  final AnimatedSpendLabelController _firstController =
      AnimatedSpendLabelController(
        LabeledAmountTracker(const Money(amountInCents: 0), label: 'Income'),
      );
  final AnimatedSpendLabelController _secondController =
      AnimatedSpendLabelController(
        LabeledAmountTracker(const Money(amountInCents: 0), label: 'Expense'),
      );

  @override
  void initState() {
    super.initState();
    _refreshControllers();
  }

  void _refreshControllers() {
    if (widget.data.isNotEmpty) {
      _firstController.setValue(widget.data[_selected].first);
      _secondController.setValue(widget.data[_selected].second);
    }
  }

  @override
  void didUpdateWidget(covariant TotalAmountWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _refreshControllers();
    }
  }

  void _onCurrencySelect(Currency? currency) {
    final ind = widget.data.indexWhere(
      (e) => e.currency.name == currency?.name,
    );
    setState(() {
      _selected = ind;
      _firstController.setValue(widget.data[ind].first);
      _secondController.setValue(widget.data[ind].second);
    });
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CurrencySelector(
            label: 'Total',
            selected: _selected,
            currencies: widget.data.map((e) => e.currency).toList(),
            onSelect: _onCurrencySelect,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: AnimatedSpendLabel(controller: _firstController)),
              Container(
                width: 1,
                height: 50,
                color: context.colorScheme.secondaryContainer,
              ),
              Expanded(
                child: AnimatedSpendLabel(controller: _secondController),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
