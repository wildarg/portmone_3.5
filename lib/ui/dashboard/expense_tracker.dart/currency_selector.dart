import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class CurrencySelector extends StatelessWidget {

  final String? label;
  final List<Currency?> currencies;
  final int selected;
  final void Function(Currency?)? onSelect;

  const CurrencySelector({
    super.key, 
    this.label,
    this.currencies = const [],
    this.selected = 0,
    this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          if (label != null)
            Text(label!),
          if (label != null)
            SizedBox(width: 8),  
          Expanded(
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList.builder(
                  itemCount: currencies.length,
                  itemBuilder:(_, ind) => 
                    ind == selected
                    ? UiButton.secondary(
                        text: currencies[ind]?.name, 
                        margins: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onTap: () => onSelect?.call(currencies[ind]),
                      )
                    : UiButton.flatRounded(
                        text: currencies[ind]?.name, 
                        textColor: context.colorScheme.primary,
                        margins: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onTap: () => onSelect?.call(currencies[ind]),
                      )
                )
              ],
            )
          )
        ],
      ),
    );
  }
  
}