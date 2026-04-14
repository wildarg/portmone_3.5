import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/editor/common/date_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_amount_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_notes_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_type_field.dart';
import 'package:portmone_bloc/ui/editor/common/toggle_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_account_field.dart';
import 'package:portmone_bloc/ui/editor/income/income_controller.dart';
import 'package:portmone_bloc/ui/editor/operation_editor.dart';

class IncomeEditor extends StatefulWidget {

  final Income? income;

  const IncomeEditor({
    super.key, 
    this.income
  });

  @override
  State<IncomeEditor> createState() => _IncomeEditorState();
}

class _IncomeEditorState extends State<IncomeEditor> {

  late IncomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = IncomeController(widget.income);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant IncomeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.income != oldWidget.income) {
      setState(() {
        _controller.dispose();
        _controller = IncomeController(widget.income);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OperationEditor(
      title: 'Income', // TODO _l10n
      validator: () => _controller.errorMessage,
      onSave: () => context.dispatch(SaveIncomeAction(_controller.draft)),
      fieldListBuilder: (ctx) => [
        EditorDateField(
          title: 'Income date', 
          value: _controller.date,
          onChange: (date) => setState(() => _controller.setDate(date)),
        ),
        PendingToggleField(
          title: 'Pending income', 
          onChange: (value) => setState(() => _controller.setPending(value)),
          value: _controller.isPending,
        ),
        TransactionTypeField(
          title: 'Income type', 
          leading: const SizedBox(width: 24),
          types:(store) => store.incomeTypesState,
          controller: _controller.typeController,
        ),
        TransactionAccountField(
          title: 'Account', 
          accountController: _controller.accountController,
          currencyController: _controller.currencyController,
        ),
        TransactionAmountField(
          title: 'Amount',
          controller: _controller.amountController,
        ),
        TransactionNotesField(
          title: 'Notes',
          tags: (store) => store.tagsState,
          controller: _controller.notesController,
        ),
      ],
    );
  }

}
