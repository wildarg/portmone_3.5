import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/model/budget_info.dart';
import 'package:portmone_bloc/ui/core/ui_card.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class BudgetInfoCard extends StatelessWidget {

  final BudgetInfo info;

  const BudgetInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return UiCard(
      width: 150,
      height: 150,
      color: context.colorScheme.surfaceContainerHigh,
      onTap: () {
        context.push('/budget/editor', extra: info.budget);
      },
      child: Container()
    );
  }
  
}