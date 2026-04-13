import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/editor/common/date_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_amount_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_notes_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_type_field.dart';
import 'package:portmone_bloc/ui/editor/common/toggle_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_account_field.dart';
import 'package:portmone_bloc/ui/editor/expense/expense_controller.dart';
import 'package:portmone_bloc/ui/editor/expense/expense_type_avatar.dart';
import 'package:portmone_bloc/ui/editor/operation_editor.dart';

class ExpenseEditor extends StatefulWidget {

  final Expense? expense;

  const ExpenseEditor({
    super.key, 
    this.expense
  });

  @override
  State<ExpenseEditor> createState() => _ExpenseEditorState();
}

class _ExpenseEditorState extends State<ExpenseEditor> {

  late ExpenseController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpenseController(widget.expense);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExpenseEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expense != oldWidget.expense) {
      setState(() {
        _controller.dispose();
        _controller = ExpenseController(widget.expense);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OperationEditor(
      title: 'Expense', // TODO _l10n
      validator: () => _controller.errorMessage,
      onSave: () => context.dispatch(SaveExpenseAction(_controller.draft)),
      fieldListBuilder: (ctx) => [
        EditorDateField(
          title: 'Expense date', 
          value: _controller.date,
          onChange: (date) => setState(() => _controller.setDate(date)),
        ),
        PendingToggleField(
          title: 'Pending expense', 
          onChange: (value) => setState(() => _controller.setPending(value)),
          value: _controller.isPending,
        ),
        TransactionTypeField(
          title: 'Expense type', 
          leading: ExpenseTypeAvatar(controller: _controller.typeController),
          types:(store) => store.expenseTypesState,
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