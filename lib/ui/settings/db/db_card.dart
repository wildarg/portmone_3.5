import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_card.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class DbCard extends StatelessWidget {
  const DbCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UiCard(
      title: 'Backup & Restore',
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            onTap: () => context.dispatch(BackupDbAction()),
            leading: UiIcon(UiIcons.backup),
            title: Text('Backup data'),
            subtitle: Text('Share the database file'),
            trailing: UiIcon(UiIcons.arrowForward),
          ),
          ListTile(
            onTap: () => context.dispatch(RestoreDbAction()),
            leading: UiIcon(UiIcons.restore),
            title: Text('Restore data'),
            subtitle: Text('Pick up local database file'),
            trailing: UiIcon(UiIcons.arrowForward),
          ),
        ],
      )
    );
  }
  
}