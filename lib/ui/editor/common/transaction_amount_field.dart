import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_text_field.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/money_text_controller.dart';

class TransactionAmountField extends StatelessWidget {

  final String title;
  final MoneyFormatTextEditingController? controller;

  const TransactionAmountField({super.key, required this.title, this.controller});

  @override
  Widget build(BuildContext context) {
    return UiTextField(
      controller: controller,
      label: 'Amount',
      leadingIcon: const SizedBox(width: 24, height: 24),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: context.textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w100,
        fontFamily: 'Montserrat',
        fontSize: 58,
        color: context.colorScheme.primary,
        height: 66 / 58
      ),
      textAlign: TextAlign.end,
    );
  }


}