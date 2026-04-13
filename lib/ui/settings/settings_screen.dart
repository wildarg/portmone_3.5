import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/settings/db/db_card.dart';
import 'package:portmone_bloc/ui/settings/dictionary/data_management_card.dart';
import 'package:portmone_bloc/ui/settings/filter/main_filter_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              MainFilterCard(),
              DataManagementCard(),
              DbCard()
            ]
          )
        ],
    );
  }
  
}