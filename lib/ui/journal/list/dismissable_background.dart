import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class DismissibleBackground extends StatelessWidget {

  const DismissableBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.colorScheme.secondaryContainer;
    final fgColor = theme.colorScheme.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(color: theme.colorScheme.onSurface.withAlpha(50), width: 2),
          bottom: BorderSide(color: theme.colorScheme.surface.withAlpha(100), width: 2),
        ),
      ),
      child: Row(
        children: [
          UiIcon(UiIcons.delete, width: 24, color: fgColor),
          const SizedBox(width: 16),
          Text('Delete', style: theme.textTheme.bodyMedium?.copyWith(color: fgColor)),
          const Spacer(),
          Text('Delete', style: theme.textTheme.bodyMedium?.copyWith(color: fgColor)),
          const SizedBox(width: 16),
          UiIcon(UiIcons.delete, width: 24, color: fgColor),
        ],
      ),
    );
  }
}
