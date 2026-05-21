import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/core/ui_switcher.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class PendingToggleField extends StatefulWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChange;

  const PendingToggleField({
    super.key,
    required this.title,
    required this.onChange,
    this.value = false,
  });

  @override
  State<PendingToggleField> createState() => _PendingToggleFieldState();
}

class _PendingToggleFieldState extends State<PendingToggleField> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant PendingToggleField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != _value) {
      setState(() {
        _value = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiSwitcher(
      activeColor: context.colorScheme.error,
      label: widget.title,
      leading: UiIcon(
        UiIcons.pending,
        color: _value
            ? context.colorScheme.error
            : context.colorScheme.onSurfaceVariant,
      ),
      value: _value,
      onChanged: (value) {
        setState(() => _value = value);
        widget.onChange(value);
      },
    );
  }
}
