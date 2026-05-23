import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/amount_tracker_info.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/ui/dashboard/expense_tracker/spend_label.dart';

class AnimatedSpendLabelController extends ChangeNotifier {
  AmountTracker? value;

  AnimatedSpendLabelController([this.value]);

  void setValue(AmountTracker value) {
    this.value = value;
    notifyListeners();
  }
}

class AnimatedSpendLabel extends StatefulWidget {
  final AnimatedSpendLabelController _controller;

  AnimatedSpendLabel({super.key, AnimatedSpendLabelController? controller})
    : _controller = controller ?? AnimatedSpendLabelController();

  @override
  State<StatefulWidget> createState() => _AnimatedSpendLabelState();
}

class _AnimatedSpendLabelState extends State<AnimatedSpendLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _prevValue = 0;
  int _currentValue = 0;

  @override
  void dispose() {
    widget._controller.removeListener(_handleUpdate);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedSpendLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._controller != oldWidget._controller) {
      oldWidget._controller.removeListener(_handleUpdate);
      _subscribe();
    }
  }

  void _subscribe() {
    widget._controller.addListener(_handleUpdate);
  }

  void _handleUpdate() {
    if (!mounted) return;
    setState(() {
      _prevValue = _currentValue;
      _currentValue = widget._controller.value?.amount.amountInCents ?? 0;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _currentValue = widget._controller.value?.amount.amountInCents ?? 0;
    _animationController.forward();
    _subscribe();
  }

  @override
  Widget build(BuildContext context) {
    final animation = IntTween(begin: _prevValue, end: _currentValue).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    final String label = _getLabel();
    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) => SpendLabel(
        amount: Money(amountInCents: animation.value),
        label: label,
      ),
    );
  }

  String _getLabel() {
    final AmountTracker? tracker = widget._controller.value;
    return switch (tracker) {
      TodayAmountTracker() => 'Today', // TODO localization
      MonthAmountTracker() => tracker.monthName,
      LabeledAmountTracker() => tracker.label,
      _ => '',
    };
  }
}
