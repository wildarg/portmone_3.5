import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_date_field.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class EditorDateField extends StatefulWidget {

  final String title;
  final DateTime? value;
  final ValueChanged<DateTime?> onChange;

  const EditorDateField({
    super.key, 
    required this.title, 
    required this.onChange,
    this.value
  });

  @override
  State<EditorDateField> createState() => _EditorDateFieldState();
}

class _EditorDateFieldState extends State<EditorDateField> {

  DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant EditorDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != _value) {
      setState(() {
        _value = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiDateField(
      leadingIcon: UiIcon(UiIcons.calendar),
      isRemovable: false,
      label: widget.title,
      value: _value,
      onChange:(value) {
        setState(() {
          _value = value;
        });
        widget.onChange(value);
      },
    );
  }
}