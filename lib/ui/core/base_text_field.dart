import 'package:flutter/material.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';

class BaseTextField extends StatelessWidget {
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? trailingIcon;
  final String? label;
  final String? value;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController? _controller;
  final FormFieldValidator<String?>? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final BoxConstraints? constraints;
  final ValueChanged<String>? onChanged;
  final TextStyle? style;
  final TextAlign? textAlign;

  BaseTextField({
    super.key,
    this.readOnly = false,
    this.onTap,
    this.trailingIcon,
    this.label,
    this.value,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.constraints,
    this.onChanged,
    this.style,
    this.textAlign,
    TextEditingController? controller,
  }) : _controller = controller ?? TextEditingController(text: value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      controller: _controller,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onChanged: onChanged,
      style: style,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        constraints: constraints,
        prefix: SizedBox(width: 16),
        suffixIcon: trailingIcon?.let((it) => UnconstrainedBox(child: it)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: label?.let(
          (it) => Padding(
            padding: const EdgeInsets.only(bottom: 32, left: 0),
            child: Text(it),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusColor: theme.colorScheme.onSurface,
        fillColor: theme.colorScheme.surfaceContainerHigh,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      ),
    );
  }
}
