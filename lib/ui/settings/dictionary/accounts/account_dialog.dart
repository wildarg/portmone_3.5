import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';

class RenameAccountDialog extends StatefulWidget {
  final Account account;

  const RenameAccountDialog({super.key, required this.account});

  @override
  State<StatefulWidget> createState() => _RenameAccountDialogState();
}

class _RenameAccountDialogState extends State<RenameAccountDialog> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.account.name);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Account'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(labelText: 'Account name'),
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
            if (newName.isNotEmpty && newName != widget.account.name) {
              context.dispatch(
                SaveAccountAction(widget.account.copyWith(name: newName)),
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
