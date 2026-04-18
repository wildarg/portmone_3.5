import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/core/ui_text_field.dart';
import 'package:portmone_bloc/utils/datetime_extensions.dart';

class UiDateField extends StatelessWidget {
  final DateTime? value;
  final Widget? leadingIcon;
  final String? label;
  final TextEditingController? controller;
  final void Function(DateTime? value)? onChange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool isRemovable;

  const UiDateField({
    super.key,
    this.value,
    this.leadingIcon,
    this.label,
    this.onChange, 
    this.controller,
    this.firstDate,
    this.lastDate,
    this.isRemovable = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return UiTextField(
      readOnly: true,
      leadingIcon: leadingIcon,
      trailingIcon: value == null || !isRemovable
        ? UiIcon(UiIcons.arrowForward, color: colorScheme.surfaceContainerHighest)
        : IconButton(
            onPressed: () => onChange?.call(null), 
            icon: const UiIcon(UiIcons.close)
          ),
      label: label,
      value: value?.fullFormat,
      onTap: () async { 
        final initial = value ?? DateTime.now();
        final first = firstDate ?? DateTime(1900);
        final last = lastDate ?? DateTime(3000);
        
        final date = await showDatePicker(
          context: context, 
          initialDate: initial.isBefore(first) ? first : (initial.isAfter(last) ? last : initial),
          firstDate: first, 
          lastDate: last,        
        );
        onChange?.call(date);
      }
    );
  }
}
