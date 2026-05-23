import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/ui/settings/dictionary/expense_types/expense_type_list_tile.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class ExpenseTypesScreen extends StatefulWidget {
  const ExpenseTypesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpenseTypesScreenState();
  }
}

class _ExpenseTypesScreenState extends State<ExpenseTypesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: UiButton.flatRounded(
          icon: UiIcons.arrowBack,
          onTap: () => context.pop(),
        ),
        title: Text('Expense Types'),
      ),
      body: StoreBuilder(
        stream: (store) => store.expenseTypesState,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: state.length,
                itemBuilder: (context, index) =>
                    ExpenseTypeListTile(transactionType: state[index]),
              ),
            ],
          );
        },
      ),
    );
  }
}
