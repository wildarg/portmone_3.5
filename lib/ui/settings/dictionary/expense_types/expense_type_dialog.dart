import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';

class RenameExpenseTypeDialog extends StatefulWidget {
  final TransactionType transactionType;

  const RenameExpenseTypeDialog({super.key, required this.transactionType});
  
  @override
  State<StatefulWidget> createState() => _RenameExpenseTypeDialogState();

}

class _RenameExpenseTypeDialogState extends State<RenameExpenseTypeDialog> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.transactionType.name);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Expense Type'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(labelText: 'Expense type name'),
        autofocus: true,
      ),
      actions: [
        UiButton.flatRounded(
          onTap: () {
            Navigator.of(context).pop();
          },
          text: 'Cancel',
        ),
        UiButton.primary(
          onTap: () {
            final newName = textController.text.trim();
            if (newName.isNotEmpty && newName != widget.transactionType.name) {
              context.dispatch(UpdateExpenseTypeAction(widget.transactionType.copyWith(name: newName)));
            }
            Navigator.of(context).pop();
          },
          text: 'Save',
        ),
      ],
    );
  }
}
