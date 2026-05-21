import 'package:flutter/material.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class ExpenseTypeAvatar extends StatefulWidget {
  final TextEditingController controller;

  const ExpenseTypeAvatar({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() {
    return _ExpenseTypeAvatarState();
  }
}

class _ExpenseTypeAvatarState extends State<ExpenseTypeAvatar> {
  String text = '';

  @override
  void initState() {
    super.initState();
    _subscribe(widget.controller);
  }

  @override
  void didUpdateWidget(covariant ExpenseTypeAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _unsubscribe(oldWidget.controller);
      _subscribe(widget.controller);
    }
  }

  void _subscribe(TextEditingController controller) {
    controller.addListener(_onChange);
    setState(() {
      text = controller.text;
    });
  }

  void _unsubscribe(TextEditingController controller) {
    controller.removeListener(_onChange);
  }

  void _onChange() {
    setState(() {
      text = widget.controller.text;
    });
  }

  @override
  void dispose() {
    _unsubscribe(widget.controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: text.toColor,
      child: text.length < 2
          ? null
          : Text(text.substring(0, 1), style: context.textTheme.labelSmall),
    );
  }
}
