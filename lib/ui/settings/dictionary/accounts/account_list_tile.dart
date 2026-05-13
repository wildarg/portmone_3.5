import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/settings/dictionary/accounts/account_dialog.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class AccountListTile extends StatelessWidget {

  final Account account;
  final VoidCallback? onTap;

  const AccountListTile({
    super.key, 
    required this.account,
    this.onTap
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final titleColor = account.isArchived ? colorScheme.surfaceContainerHighest : colorScheme.onSurface;
    final subtitleColor = account.isArchived ? colorScheme.surfaceContainerHighest : colorScheme.primary;
    final label = account.isArchived ? 'Restore' : 'Archive';

    return ListTile(
      key: ValueKey(account.uid),
      title: Text(
        account.name,
        style: theme.textTheme.titleMedium?.copyWith(color: titleColor),
      ),
      subtitle: Text(
        account.currency.name,
        style: theme.textTheme.bodySmall?.copyWith(color: subtitleColor),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiButton.flatRounded(
            icon: account.isArchived ? UiIcons.unarchiveFill : UiIcons.archive,
            onTap: () => context.dispatch(SaveAccountAction(account.copyWith(isArchived: !account.isArchived))),
          ),
          Text(label)
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return RenameAccountDialog(account: account);
          },
        );
      },
    );
  }  
}