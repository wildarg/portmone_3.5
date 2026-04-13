import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_card.dart';
import 'package:portmone_bloc/ui/reports/balance/total_balance_list_tile.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UiCard(
      title: 'Total Balance',
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      child: StoreBuilder(
        stream: (store) => store.totalBalanceState,
        builder: (context, state) {          
          return Column(
            children: state.map((e) => 
              TotalBalanceListTile(
                name: e.currency.name, 
                enter: e.enter, 
                exit: e.exit
              )
            ).toList()
          );
        }
      )
    );
  }
  
}