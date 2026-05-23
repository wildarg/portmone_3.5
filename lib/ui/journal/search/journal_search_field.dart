import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/model/amount_tracker_info.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/date_transactions.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/core/ui_text_field.dart';
import 'package:portmone_bloc/ui/journal/search/total_amount_widget.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:rxdart/rxdart.dart';

class JournalSearchField extends StatefulWidget {
  final FocusNode? focusNode;

  const JournalSearchField({super.key, this.focusNode});

  @override
  State<JournalSearchField> createState() => _JournalSearchFieldState();
}

class _JournalSearchFieldState extends State<JournalSearchField>
    with SingleTickerProviderStateMixin {
  final StreamController<VoidCallback> _controller = StreamController();
  late AnimationController _clearButtonAnimation;
  final TextEditingController _textController = TextEditingController();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _controller.stream
        .debounceTime(const Duration(milliseconds: 300))
        .listen((action) => action.call());
    _clearButtonAnimation = AnimationController(
      vsync: this,
      duration: Durations.medium1,
    );
    _textController.text = context.store.filterState.value.text;
    Future.delayed(Durations.medium1, () {
      if (mounted && _textController.text.isNotEmpty) {
        _clearButtonAnimation.forward();
      }
    });
    _subscription = context.store.filterState.listen(_onFilterChange);
  }

  void _onFilterChange(MainFilter filter) {
    if (_textController.text != filter.text) {
      _textController.text = filter.text;
      if (filter.text.isNotEmpty) {
        _clearButtonAnimation.forward();
      } else {
        _clearButtonAnimation.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiTextField(
      controller: _textController,
      leadingIcon: UiIcon(UiIcons.search),
      focusNode: widget.focusNode,
      trailingIcon: UnconstrainedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiButton.flatRounded(
              icon: UiIcons.receipt2,
              iconSize: 16,
              textColor: context.colorScheme.primary,
              onTap: () {
                widget.focusNode?.unfocus();
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      height: 200,
                      padding: const EdgeInsets.all(24),
                      child: TotalAmountWidget(
                        data: _getAmountTrackerData(
                          context.store.journalState.value,
                        ),
                        onClose: context.pop,
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(width: 8),
            UiButton.flatRounded(
              icon: UiIcons.close,
              iconSize: 16,
              onTap: () {
                widget.focusNode?.unfocus();
                _textController.clear();
                context.dispatch(SetTextFilterAction(''));
                _clearButtonAnimation.reverse();
              },
            ),
          ],
        ),
      ).animate(controller: _clearButtonAnimation, autoPlay: false).scale(),
      constraints: const BoxConstraints.tightFor(height: 38),
      onChanged: (value) {
        if (value.isNotEmpty) {
          _clearButtonAnimation.forward();
        } else {
          _clearButtonAnimation.reverse();
        }
        _controller.sink.add(() {
          context.dispatch(SetTextFilterAction(value));
        });
      },
    );
  }

  List<AmountTrackerData> _getAmountTrackerData(
    List<DateTransactions> journal,
  ) {
    final Map<String, _CurrencyTotals> totals = {};
    for (final dateGroup in journal) {
      for (final tx in dateGroup.transactions) {
        switch (tx) {
          case Income():
            final key = tx.account.currency.uid;
            final entry = totals.putIfAbsent(
              key,
              () => _CurrencyTotals(tx.account.currency),
            );
            entry.income += tx.amount.amountInCents;
          case Expense():
            final key = tx.account.currency.uid;
            final entry = totals.putIfAbsent(
              key,
              () => _CurrencyTotals(tx.account.currency),
            );
            entry.expense += tx.amount.amountInCents;
          default:
            break;
        }
      }
    }
    return totals.values
        .map(
          (e) => AmountTrackerData(
            currency: e.currency,
            first: LabeledAmountTracker(
              Money(amountInCents: e.income),
              label: 'Income',
            ),
            second: LabeledAmountTracker(
              Money(amountInCents: e.expense),
              label: 'Expense',
            ),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
    _clearButtonAnimation.dispose();
    super.dispose();
  }
}

class _CurrencyTotals {
  final Currency currency;
  int income = 0;
  int expense = 0;
  _CurrencyTotals(this.currency);
}
