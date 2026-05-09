import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_card.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class NewBudgetCard extends StatelessWidget {

  const NewBudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UiCard(
      width: 150,
      height: 120,
      color: context.colorScheme.secondaryContainer,
      highlightColor: context.colorScheme.secondary.withAlpha(50),
      splashColor: context.colorScheme.secondary.withAlpha(100),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      onTap: () {
        context.push('/budget/editor');
      },
      child: Column(
        children: [
          UiButton.flatRounded(
            icon: UiIcons.newBudget,
          ),
          Text('Add new budget', style: context.textTheme.labelMedium),
        ],
      )
    );
  }
  
}