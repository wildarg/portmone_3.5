import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_text_field.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';
import 'package:portmone_bloc/utils/money_text_controller.dart';

class MoneyCalculatorSheet extends StatefulWidget {
  final int initialAmount;

  const MoneyCalculatorSheet({
    super.key,
    required this.initialAmount,
  });

  @override
  State<MoneyCalculatorSheet> createState() => _MoneyCalculatorSheetState();
}

class _MoneyCalculatorSheetState extends State<MoneyCalculatorSheet> {
  late final MoneyFormatTextEditingController _calcController;
  double? _operand1;
  String? _operation;
  bool _resetInputOnNextDigit = false;

  @override
  void initState() {
    super.initState();
    _calcController = MoneyFormatTextEditingController(cents: widget.initialAmount);
    if (widget.initialAmount == 0) {
      _calcController.value = const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }
  }

  @override
  void dispose() {
    _calcController.dispose();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    setState(() {
      if (_resetInputOnNextDigit) {
        _resetInputOnNextDigit = false;
        _calcController.value = TextEditingValue(
          text: digit,
          selection: TextSelection.collapsed(offset: digit.length),
        );
        return;
      }

      final text = _calcController.text;
      final selection = _calcController.selection;
      
      final start = selection.start >= 0 ? selection.start : text.length;
      final end = selection.end >= 0 ? selection.end : text.length;
      
      final newText = text.replaceRange(start, end, digit);
      final cursorPosition = start + digit.length;
      
      _calcController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: cursorPosition),
      );
    });
  }

  void _onBackspacePressed() {
    setState(() {
      final text = _calcController.text;
      if (text.isEmpty) return;
      
      final selection = _calcController.selection;
      final start = selection.start >= 0 ? selection.start : text.length;
      final end = selection.end >= 0 ? selection.end : text.length;
      
      if (start == end) {
        if (start > 0) {
          final newText = text.replaceRange(start - 1, start, '');
          _calcController.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: start - 1),
          );
        }
      } else {
        final newText = text.replaceRange(start, end, '');
        _calcController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: start),
        );
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _calcController.value = const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
      _operand1 = null;
      _operation = null;
      _resetInputOnNextDigit = false;
    });
  }

  void _onOperationPressed(String op) {
    setState(() {
      if (_calcController.text.isNotEmpty) {
        if (_operation != null) {
          _evaluate();
        }
        _operand1 = _calcController.amount / 100.0;
        _calcController.value = const TextEditingValue(
          text: "",
          selection: TextSelection.collapsed(offset: 0),
        );
      }
      _operation = op;
    });
  }

  void _evaluate() {
    if (_operand1 == null || _operation == null) return;
    final operand2 = _calcController.amount / 100.0;
    double result = 0;
    switch (_operation) {
      case '+':
        result = _operand1! + operand2;
        break;
      case '-':
        result = _operand1! - operand2;
        break;
      case '*':
        result = _operand1! * operand2;
        break;
      case '/':
        if (operand2 != 0) {
          result = _operand1! / operand2;
        } else {
          result = 0;
        }
        break;
    }
    
    final centsResult = (result * 100).round();
    _calcController.amount = centsResult;
  }

  void _onEqualsPressed() {
    if (_operation != null) {
      setState(() {
        _evaluate();
        _operation = null;
        _operand1 = null;
        _resetInputOnNextDigit = true;
      });
    } else {
      Navigator.pop(context, _calcController.amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double spacing = 8.0;
    final double unitWidth = (screenWidth - 32.0 - (3.0 * spacing)) / 4.0;
    final double doubleWidth = (2.0 * unitWidth) + spacing;
    const double buttonHeight = 52.0;

    final String? formulaText = (_operand1 != null && _operation != null)
        ? '${(_operand1! * 100).round().asFormattedAmount} $_operation'
        : null;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28.0),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: MediaQuery.of(context).padding.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          
          // Formula indicator / Title
          SizedBox(
            height: 20.0,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                formulaText ?? 'Calculator',
                style: context.textTheme.labelMedium?.copyWith(
                  color: formulaText != null
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: formulaText != null ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          
          // Display TextField
          UiTextField(
            controller: _calcController,
            readOnly: true,
            style: context.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w100,
              fontFamily: 'Montserrat',
              fontSize: 48,
              color: context.colorScheme.primary,
              height: 56 / 48,
            ),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 20.0),
          
          // Keypad Rows
          Column(
            spacing: spacing,
            children: [
              // Row 1: C, ⌫, 00, /
              Row(
                spacing: spacing,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(text: 'C', onTap: _onClearPressed, isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '⌫', onTap: _onBackspacePressed, isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '00', onTap: () => _onDigitPressed('00'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '/', onTap: () => _onOperationPressed('/'), isPrimary: true, width: unitWidth, height: buttonHeight),
                ],
              ),
              // Row 2: 7, 8, 9, *
              Row(
                spacing: spacing,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(text: '7', onTap: () => _onDigitPressed('7'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '8', onTap: () => _onDigitPressed('8'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '9', onTap: () => _onDigitPressed('9'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '*', onTap: () => _onOperationPressed('*'), isPrimary: true, width: unitWidth, height: buttonHeight),
                ],
              ),
              // Row 3: 4, 5, 6, -
              Row(
                spacing: spacing,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(text: '4', onTap: () => _onDigitPressed('4'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '5', onTap: () => _onDigitPressed('5'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '6', onTap: () => _onDigitPressed('6'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '-', onTap: () => _onOperationPressed('-'), isPrimary: true, width: unitWidth, height: buttonHeight),
                ],
              ),
              // Row 4: 1, 2, 3, +
              Row(
                spacing: spacing,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(text: '1', onTap: () => _onDigitPressed('1'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '2', onTap: () => _onDigitPressed('2'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '3', onTap: () => _onDigitPressed('3'), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(text: '+', onTap: () => _onOperationPressed('+'), isPrimary: true, width: unitWidth, height: buttonHeight),
                ],
              ),
              // Row 5: 0 (double width), ., =/Done
              Row(
                spacing: spacing,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(text: '0', onTap: () => _onDigitPressed('0'), isPrimary: false, width: doubleWidth, height: buttonHeight),
                  _buildButton(text: Separator.decimal, onTap: () => _onDigitPressed(Separator.decimal), isPrimary: false, width: unitWidth, height: buttonHeight),
                  _buildButton(
                    text: _operation != null ? '=' : 'Done',
                    onTap: _onEqualsPressed,
                    isPrimary: true,
                    width: unitWidth,
                    height: buttonHeight,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
    required double width,
    required double height,
  }) {
    return UiButton(
      buttonType: isPrimary ? ButtonType.primary : ButtonType.secondary,
      width: width,
      height: height,
      radius: 16.0,
      padding: isPrimary 
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          : const EdgeInsets.all(8),
      iconSize: 20.0,
      text: text,
      onTap: onTap,
    );
  }
}
