import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/editor/common/date_field.dart';
import 'package:portmone_bloc/ui/editor/common/focus_node_group.dart';
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
  late FocusNodeGroup _nodes;

  @override
  void initState() {
    super.initState();
    _controller = ExpenseController(widget.expense);
    _nodes = FocusNodeGroup(4);
  }

  @override
  void dispose() {
    _controller.dispose();
    _nodes.dispose();
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
      canPopUp: () {
        if (_nodes.hasFocus) {
          _nodes.unfocus();
          return false;
        }
        return true;
      },
      fieldListBuilder: (ctx) => [
        EditorDateField(
          title: 'Expense date', 
          value: _controller.date,
          onChange: (date) => setState(() => _controller.setDate(date)),
        ),
        PendingToggleField(
          title: 'Pending expense', 
          onChange: (value) {
            _nodes.unfocus();
            setState(() => _controller.setPending(value));
          },
          value: _controller.isPending,
        ),
        TransactionTypeField(
          title: 'Expense type', 
          leading: ExpenseTypeAvatar(controller: _controller.typeController),
          types:(store) => store.expenseTypesState,
          controller: _controller.typeController,
          focusNode: _nodes[0],
        ),
        TransactionAccountField(
          title: 'Account', 
          accountController: _controller.accountController,
          currencyController: _controller.currencyController,
          accountFocusNode: _nodes[1],
          currencyFocusNode: _nodes[2],
        ),
        TransactionAmountField(
          title: 'Amount',
          controller: _controller.amountController,
        ),
        TransactionNotesField(
          title: 'Notes',
          tags: (store) => store.tagsState,
          controller: _controller.notesController, 
          focusNode: _nodes[3],
        ),
      ],
    );
  }

}