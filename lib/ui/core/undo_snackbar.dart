import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class UndoSnackbar {

  static SnackBar build({required BuildContext context, required String label, VoidCallback? onUndo}) {
    final theme = Theme.of(context);
    
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      content: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ]
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            UiIcon(
              UiIcons.delete, 
              width: 24, 
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (onUndo != null)
              UiButton.flatRounded(
                text: 'UNDO', 
                textColor: theme.colorScheme.primary, 
                onTap: onUndo,
              )
          ],
        ),
      ),
    );
  }
}
