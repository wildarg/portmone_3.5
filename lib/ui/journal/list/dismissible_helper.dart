import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/model/transaction.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/undo_snackbar.dart';

class DismissibleHelper {
  static void onDismiss(BuildContext context, Transaction operation) {
    final (label, deleteAction, undoAction) = switch (operation) {
      Expense() => (
        'Expense deleted',
        DeleteExpenseAction(operation),
        RestoreExpenseAction(operation),
      ),
      Income() => (
        'Income deleted',
        DeleteIncomeAction(operation),
        RestoreIncomeAction(operation),
      ),
      Transfer() => (
        'Transfer deleted',
        DeleteTransferAction(operation),
        RestoreTransferAction(operation),
      ),
      _ => throw ArgumentError('Unknown operation'),
    };

    context.dispatch(deleteAction);
    final store = context.store;
    final messenger = ScaffoldMessenger.of(context);
    final snackBar = UndoSnackbar.build(
      context: context,
      label: label,
      onUndo: () {
        store.dispatch(undoAction);
        messenger.hideCurrentSnackBar();
      },
    );

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(snackBar);
  }
}
