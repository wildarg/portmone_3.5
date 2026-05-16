import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/settings/dictionary/income_types/income_type_dialog.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class IncomeTypeListTile extends StatelessWidget {

  final TransactionType transactionType;
  final VoidCallback? onTap;

  const IncomeTypeListTile({
    super.key, 
    required this.transactionType,
    this.onTap
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final titleColor = transactionType.isArchived ? colorScheme.surfaceContainerHighest : colorScheme.onSurface;
    final label = transactionType.isArchived ? 'Restore' : 'Archive';

    return ListTile(
      key: ValueKey(transactionType.uid),
      title: Text(
        transactionType.name,
        style: theme.textTheme.titleMedium?.copyWith(color: titleColor),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiButton.flatRounded(
            icon: transactionType.isArchived ? UiIcons.unarchiveFill : UiIcons.archive,
            onTap: () => context.dispatch(UpdateIncomeTypeAction(transactionType.copyWith(isArchived: !transactionType.isArchived))),
          ),
          Text(label)
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return RenameIncomeTypeDialog(transactionType: transactionType);
          },
        );
      },
    );
  }  
}
