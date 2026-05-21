import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';

class RenameIncomeTypeDialog extends StatefulWidget {
  final TransactionType transactionType;

  const RenameIncomeTypeDialog({super.key, required this.transactionType});

  @override
  State<StatefulWidget> createState() => _RenameIncomeTypeDialogState();
}

class _RenameIncomeTypeDialogState extends State<RenameIncomeTypeDialog> {
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
      title: const Text('Rename Income Type'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(labelText: 'Income type name'),
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
              context.dispatch(
                UpdateIncomeTypeAction(
                  widget.transactionType.copyWith(name: newName),
                ),
              );
            }
            Navigator.of(context).pop();
          },
          text: 'Save',
        ),
      ],
    );
  }
}
