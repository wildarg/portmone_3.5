import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_autocomplete_field.dart';

class TransactionAccountField extends StatelessWidget {
  final String title;
  final TextEditingController accountController;
  final TextEditingController currencyController;
  final FocusNode? accountFocusNode;
  final FocusNode? currencyFocusNode;

  const TransactionAccountField({
    super.key,
    required this.title,
    required this.accountController,
    required this.currencyController,
    this.accountFocusNode,
    this.currencyFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          flex: 2,
          child: StoreBuilder(
            stream: (store) => store.accountsState,
            builder: (_, state) => UiAutocompleteField<Account>(
              leadingIcon: SizedBox(width: 24),
              label: title,
              displayStringForText: (account) => account.name,
              toLabel: (account) => account.fullName,
              suggestions: state,
              controller: accountController,
              onSelected: (account) {
                  currencyController.text = account?.currency.name ?? '';
              },
              focusNode: accountFocusNode,
            ),
          ),
        ),
        Flexible(
          child: StoreBuilder(
            stream: (store) => store.currenciesState,
            builder: (_, state) => UiAutocompleteField<Currency>(
              label: 'Currency',
              displayStringForText: (value) => value.name,
              suggestions: state,
              controller: currencyController,
              focusNode: currencyFocusNode,
            ),
          ),
        ),
      ],
    );
  }
}
