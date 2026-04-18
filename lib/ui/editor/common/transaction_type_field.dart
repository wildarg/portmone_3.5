import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_autocomplete_field.dart';
import 'package:rxdart/rxdart.dart';

class TransactionTypeField extends StatelessWidget {

  final String title;
  final Widget? leading;
  final BehaviorSubject<List<TransactionType>> Function(PortmoneStore store) types;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const TransactionTypeField({
    super.key,
    this.leading,
    required this.title,
    required this.types,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      stream: types,
      builder: (_, state) => UiAutocompleteField<TransactionType>(
        leadingIcon: leading ?? SizedBox(width: 24),
        label: title,
        displayStringForText: (value) => value.name,
        suggestions: state,
        controller: controller,
        focusNode: focusNode,
      ),
    );
  }

}