import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/budget.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/model/money_date_info.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_autocomplete_field.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/core/ui_switcher.dart';
import 'package:portmone_bloc/ui/core/ui_text_field.dart';
import 'package:portmone_bloc/ui/editor/budget/budget_chart.dart';
import 'package:portmone_bloc/ui/editor/budget/budget_controller.dart';
import 'package:portmone_bloc/ui/editor/common/focus_node_group.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class BudgetEditor extends StatefulWidget {
  final Budget? budget;

  const BudgetEditor({
    super.key,
    this.budget,
  });

  @override
  State<BudgetEditor> createState() => _BudgetEditorState();
}

class _BudgetEditorState extends State<BudgetEditor> {
  late BudgetController _controller;
  late FocusNodeGroup _nodes;

  @override
  void initState() {
    super.initState();
    _nodes = FocusNodeGroup(3);
    _controller = BudgetController(
      widget.budget, 
      context.store.filterState.value, 
      context.store.expenseRecordsState.value
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _nodes.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BudgetEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.budget != oldWidget.budget) {
      setState(() {
        _controller.dispose();
        _controller = BudgetController(
          widget.budget, 
          context.store.filterState.value, 
          context.store.expenseRecordsState.value
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainer,
      appBar: AppBar(
        leading: IconButton(
          icon: UiIcon(UiIcons.arrowBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: context.colorScheme.surfaceContainer,
        title: const Text('Budget'),
        centerTitle: true,
        actions: [
          if (widget.budget != null)
            IconButton(
              icon: UiIcon(UiIcons.delete),
              onPressed: () {
                context.dispatch(DeleteBudgetAction(widget.budget!));
                Navigator.of(context).pop();
              },
            ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            UiTextField(
              label: 'Name',
              leadingIcon: UiIcon(UiIcons.dataThresholding),
              controller: _controller.nameController,
              focusNode: _nodes[0],
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: UiTextField(
                    label: 'Amount',
                    leadingIcon: SizedBox(),
                    controller: _controller.amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.end,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                    focusNode: _nodes[1],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: StoreBuilder(
                    stream: (store) => store.currenciesState,
                    builder: (context, currencies) {
                      return UiAutocompleteField<String>(
                        label: 'Currency',
                        controller: _controller.currencyController,
                        suggestions: currencies.map((e) => e.name).toList(),
                        displayStringForText: (e) => e,
                        focusNode: _nodes[2],
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ValueListenableBuilder<List<MoneyDateInfo>>(
                valueListenable: _controller.chartData,
                builder: (context, data, _) {
                  return BudgetChart(
                    data: data,
                    limit: Money(amountInCents: _controller.amountController.amount),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Expense types',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            StoreBuilder(
              stream: (store) => store.expenseTypesState,
              builder: (context, types) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: types.length,
                    itemBuilder: (context, index) {
                      final type = types[index];
                      return UiSwitcher(
                        label: type.name,
                        value: _controller.expenseTypeUids.contains(type.uid),
                        onChanged: (value) {
                          _nodes.unfocus();
                          setState(() {
                            _controller.toggleExpenseTypeUid(type.uid);
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(                  
          style: FilledButton.styleFrom(      
            elevation: 8,
            fixedSize: Size(0, 50),
            padding: const EdgeInsets.all(0),     
            textStyle: context.textTheme.bodyLarge,
          ),
          onPressed: () {
            final error = _controller.errorMessage;
            if (error != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
              return;
            }
            context.dispatch(SaveBudgetAction(_controller.draft));
            Navigator.of(context).pop();
          },
          child: Text('Save')
        ),        
      ),
    );
  }
}
