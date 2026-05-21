import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/ui/settings/dictionary/income_types/income_type_list_tile.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class IncomeTypesScreen extends StatefulWidget {
  const IncomeTypesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IncomeTypesScreenState();
  }
}

class _IncomeTypesScreenState extends State<IncomeTypesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: UiButton.flatRounded(
          icon: UiIcons.arrowBack,
          onTap: () => context.pop(),
        ),
        title: Text('Income Types'),
      ),
      body: StoreBuilder(
        stream: (store) => store.incomeTypesState,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: state.length,
                itemBuilder: (context, index) =>
                    IncomeTypeListTile(transactionType: state[index]),
              ),
            ],
          );
        },
      ),
    );
  }
}
