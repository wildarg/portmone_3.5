import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/core/ui_scrollable_swimlane.dart';

class QuickActionLane extends StatelessWidget {
  const QuickActionLane({super.key});

  @override
  Widget build(BuildContext context) {
    return UiScrollableSwimlane(
      items: [
        const SizedBox(width: 16),
        UiButton.primarySmall(          
          icon: UiIcons.receipt, 
          text: 'Expense',
          onTap: () => context.push('/expense/editor'),
        ),
        const SizedBox(width: 8),
        UiButton.primarySmall(          
          icon: UiIcons.currencyExchange, 
          text: 'Transfer',
          onTap: () => context.push('/transfer/editor'),
        ),
        const SizedBox(width: 8),
        UiButton.primarySmall(          
          icon: UiIcons.wallet, 
          text: 'Income',
          onTap: () => context.push('/income/editor'),
        ),
        const SizedBox(width: 16),
      ],
    );  
  }
  
}