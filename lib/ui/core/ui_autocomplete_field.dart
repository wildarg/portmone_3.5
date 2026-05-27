import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/base_text_field.dart';
import 'package:portmone_bloc/ui/core/custom_autocomplete_options_view.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class UiAutocompleteField<T extends Object> extends StatelessWidget {
  final T? value;
  final List<T> suggestions;
  final Widget? leadingIcon;
  final String? label;
  final void Function(T? value)? onSelected;
  final Widget? trailingIcon;
  final TextEditingController controller;
  final FocusNode _focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final String Function(T value) displayStringForText;
  final String Function(T value)? toLabel;
  final bool multiSelect;

  UiAutocompleteField({
    super.key,
    this.value,
    this.suggestions = const [],
    this.leadingIcon,
    this.label,
    this.onSelected,
    this.trailingIcon,
    required this.controller,
    FocusNode? focusNode,
    this.onFieldSubmitted,
    required this.displayStringForText,
    this.toLabel,
    this.multiSelect = false,
  }) : _focusNode = focusNode ?? FocusNode(debugLabel: 'autocomplete-$label');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: label != null ? 16 : 0),
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          return ListTile(
            leading: leadingIcon,
            contentPadding: const EdgeInsets.all(0),
            title: Autocomplete<T>(
              optionsBuilder: (textEditingValue) {
                return multiSelect
                    ? _getTags(textEditingValue, suggestions)
                    : suggestions.where(
                        (e) => displayStringForText(e).toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                      );
              },
              onSelected:(option) { 
                onSelected?.call(option);
              },
              optionsViewBuilder: (context, onOptionSelect, options) {
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: CustomAutocompleteOptionsView<T>(
                        displayStringForOption: toLabel ?? displayStringForText,
                        onSelected: (option) {
                          final String optionText = displayStringForText(
                            option,
                          );
                          if (multiSelect) {
                            var (String newText, int position) = controller
                                .text
                                .replaceActiveWord(
                                  controller.selection.start,
                                  optionText,
                                );
                            onOptionSelect(option);
                            controller.value = TextEditingValue(
                              text: newText,
                              selection: TextSelection.fromPosition(
                                TextPosition(offset: position),
                              ),
                            );
                          } else {
                            onOptionSelect(option);
                            // _controller.value = TextEditingValue(
                            //   text: optionText,
                            //   selection: TextSelection.collapsed(offset: optionText.length)
                            // );
                          }
                          onSelected?.call(option);
                          // onSelected(option);
                        },
                        options: options,
                        maxOptionsHeight: 200,
                        maxOptionWidth: constraints.maxWidth - 0 + 0,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: UiIcon(UiIcons.close, width: 24),
                        onPressed: () {
                          _focusNode.unfocus();
                        },
                      ),
                    ),
                  ],
                );
              },
              displayStringForOption: displayStringForText,
              focusNode: _focusNode,
              textEditingController: controller,
              fieldViewBuilder:
                  (
                    context,
                    controller,
                    focusNode,
                    onAutocompleteFieldSubmitted,
                  ) => BaseTextField(
                    trailingIcon: trailingIcon,
                    label: label,
                    value: value == null ? null : displayStringForText(value!),
                    focusNode: focusNode,
                    controller: controller,
                    onFieldSubmitted: (v) {
                      focusNode.unfocus();
                      // final bool shouldSelect = multiSelect
                      //     ? v
                      //           .getActiveWord(controller.selection.start)
                      //           .isNotEmpty
                      //     : v.trim().isNotEmpty;

                      // if (shouldSelect) {
                      //   onAutocompleteFieldSubmitted();
                      // } else {
                      //   focusNode.unfocus();
                      // }
                      // onFieldSubmitted?.call(v);
                    },
                  ),
            ),
          );
        },
      ),
    );
  }

  FutureOr<Iterable<T>> _getTags(TextEditingValue value, Iterable<T> options) {
    final String s = value.text.trim().toLowerCase();
    final String tag = s.getActiveWord(controller.selection.start);
    return options.where(
      (e) => tag.isEmpty || displayStringForText(e).toLowerCase().contains(tag),
    );
  }
}
