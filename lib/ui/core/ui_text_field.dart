import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/base_text_field.dart';

class UiTextField extends StatelessWidget {
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final String? label;
  final String? value;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String?>? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final BoxConstraints? constraints;
  final ValueChanged<String>? onChanged;
  final TextStyle? style;
  final TextAlign? textAlign;

  const UiTextField({
    super.key, 
    this.readOnly = false,
    this.label,
    this.onTap,
    this.leadingIcon,
    this.trailingIcon,
    this.value,
    this.focusNode,
    this.onFieldSubmitted,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.constraints,
    this.onChanged,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: label != null ? 16 : 0),
      child: ListTile(
        leading: leadingIcon,
        contentPadding: EdgeInsets.zero,
        title: BaseTextField(
          readOnly: readOnly,
          onTap: onTap,
          trailingIcon: trailingIcon,
          label: label,
          value: value,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          constraints: constraints,
          onChanged: onChanged,
          style: style,
          textAlign: textAlign,
        )
      ),
    );
  }
}
