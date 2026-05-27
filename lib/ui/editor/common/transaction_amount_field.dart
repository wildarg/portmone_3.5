import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_text_field.dart';
import 'package:portmone_bloc/ui/editor/common/money_calculator_sheet.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/money_text_controller.dart';

class TransactionAmountField extends StatelessWidget {
  final String title;
  final MoneyFormatTextEditingController? controller;

  const TransactionAmountField({
    super.key,
    required this.title,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return UiTextField(
      controller: controller,
      label: 'Amount',
      leadingIcon: const SizedBox(width: 24, height: 24),
      trailingIcon: controller != null
          ? IconButton(
              icon: Icon(
                Icons.calculate_outlined,
                color: context.colorScheme.primary,
              ),
              onPressed: () async {
                final result = await showModalBottomSheet<int>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => MoneyCalculatorSheet(
                    initialAmount: controller!.amount,
                  ),
                );
                if (result != null) {
                  controller!.amount = result;
                }
              },
            )
          : null,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: context.textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w100,
        fontFamily: 'Montserrat',
        fontSize: 58,
        color: context.colorScheme.primary,
        height: 66 / 58,
      ),
      textAlign: TextAlign.end,
    );
  }
}

