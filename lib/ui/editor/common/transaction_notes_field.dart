import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_autocomplete_field.dart';
import 'package:rxdart/rxdart.dart';

class TransactionNotesField extends StatelessWidget {
  final String title;
  final Widget? leading;
  final BehaviorSubject<List<String>> Function(PortmoneStore store) tags;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const TransactionNotesField({
    super.key,
    this.leading,
    required this.title,
    required this.tags,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      stream: tags,
      builder: (_, state) => UiAutocompleteField<String>(
        leadingIcon: leading ?? SizedBox(width: 24),
        label: title,
        multiSelect: true,
        displayStringForText: (value) => value,
        suggestions: state,
        controller: controller,
        focusNode: focusNode,
      ),
    );
  }
}
