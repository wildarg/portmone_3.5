import 'package:flutter/material.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class UiSwitcher extends StatelessWidget {
  final Widget? leading;
  final bool value;
  final String label;
  final void Function(bool value)? onChanged;
  final Color? activeColor;

  const UiSwitcher({
    super.key,
    this.label = '',
    this.leading,
    this.value = false,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: value ? activeColor : context.colorScheme.onSurface,
              ),
            ),
          ),
          Switch(
            activeThumbColor: activeColor,
            inactiveThumbColor: context.colorScheme.surfaceContainerHighest,
            inactiveTrackColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHigh,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
