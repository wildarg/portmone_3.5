import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/ui/core/ui_card.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class DataManagementCard extends StatelessWidget {
  const DataManagementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UiCard(
      title: 'Data management',
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            onTap: () => context.pushNamed('accounts'),
            leading: UiIcon(UiIcons.accounts),
            title: Text('Accounts'),
            trailing: UiIcon(UiIcons.arrowForward),
          ),
          ListTile(
            onTap: () => context.pushNamed('expenseTypes'),
            leading: UiIcon(UiIcons.receipt),
            title: Text('Expense Types'),
            trailing: UiIcon(UiIcons.arrowForward),
          ),
          ListTile(
            onTap: () => context.pushNamed('incomeTypes'),
            leading: UiIcon(UiIcons.wallet2),
            title: Text('Income Types'),
            trailing: UiIcon(UiIcons.arrowForward),
          ),
          ListTile(
            onTap: () => context.pushNamed('tags'),
            leading: UiIcon(UiIcons.tag),
            title: Text('Tags'),
            trailing: UiIcon(UiIcons.arrowForward),
          ),
        ],
      ),
    );
  }
}
