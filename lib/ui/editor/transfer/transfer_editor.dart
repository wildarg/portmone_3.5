import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/editor/common/date_field.dart';
import 'package:portmone_bloc/ui/editor/common/focus_node_group.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_amount_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_notes_field.dart';
import 'package:portmone_bloc/ui/editor/common/toggle_field.dart';
import 'package:portmone_bloc/ui/editor/common/transaction_account_field.dart';
import 'package:portmone_bloc/ui/editor/operation_editor.dart';
import 'package:portmone_bloc/ui/editor/transfer/transfer_controller.dart';

class TransferEditor extends StatefulWidget {
  final Transfer? transfer;

  const TransferEditor({
    super.key,
    this.transfer,
  });

  @override
  State<TransferEditor> createState() => _TransferEditorState();
}

class _TransferEditorState extends State<TransferEditor> {
  late TransferController _controller;
  late FocusNodeGroup _nodes;

  @override
  void initState() {
    super.initState();
    _controller = TransferController(widget.transfer);
    _nodes = FocusNodeGroup(5);
  }

  @override
  void dispose() {
    _controller.dispose();
    _nodes.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TransferEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transfer != oldWidget.transfer) {
      setState(() {
        _controller.dispose();
        _controller = TransferController(widget.transfer);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO _l10n
    return OperationEditor(
      title: 'Transfer',
      validator: () => _controller.errorMessage,
      onSave: () => context.dispatch(SaveTransferAction(_controller.draft)),
      canPopUp: () {
        if (_nodes.hasFocus) {
          _nodes.unfocus();
          return false;
        }
        return true;
      },
      fieldListBuilder: (ctx) => [
        EditorDateField(
          title: 'Transfer date',
          value: _controller.date,
          onChange: (date) => setState(() => _controller.setDate(date)),
        ),
        PendingToggleField(
          title: 'Pending transfer',
          onChange: (value) {
            _nodes.unfocus();
            setState(() => _controller.setPending(value));
          },
          value: _controller.isPending,
        ),
        TransactionAccountField(
          title: 'From Account',
          accountController: _controller.fromAccountController,
          currencyController: _controller.fromCurrencyController,
          accountFocusNode: _nodes[0],
          currencyFocusNode: _nodes[1],
        ),
        TransactionAmountField(
          title: 'From Amount',
          controller: _controller.fromAmountController,
        ),
        TransactionAccountField(
          title: 'To Account',
          accountController: _controller.toAccountController,
          currencyController: _controller.toCurrencyController,
          accountFocusNode: _nodes[2],
          currencyFocusNode: _nodes[3],
        ),
        TransactionAmountField(
          title: 'To Amount',
          controller: _controller.toAmountController,
        ),
        TransactionNotesField(
          title: 'Notes',
          tags: (store) => store.tagsState,
          controller: _controller.notesController,
          focusNode: _nodes[4],
        ),
      ],
    );
  }
}
