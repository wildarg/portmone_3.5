import 'package:flutter/material.dart';

class UiText extends StatelessWidget {
  final String text;
  final TextStyle? Function(BuildContext context)? styleBuilder;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const UiText(
    this.text, {
    super.key,
    this.styleBuilder,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  factory UiText.displayLarge(String text, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) =>
    UiText(text, styleBuilder: (ctx) => Theme.of(ctx).textTheme.displayLarge, textAlign: textAlign, maxLines: maxLines, overflow: overflow);

  factory UiText.titleLarge(String text, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) =>
    UiText(text, styleBuilder: (ctx) => Theme.of(ctx).textTheme.titleLarge, textAlign: textAlign, maxLines: maxLines, overflow: overflow);

  factory UiText.titleMedium(String text, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) =>
    UiText(text, styleBuilder: (ctx) => Theme.of(ctx).textTheme.titleMedium, textAlign: textAlign, maxLines: maxLines, overflow: overflow);
    
  factory UiText.bodyLarge(String text, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) =>
    UiText(text, styleBuilder: (ctx) => Theme.of(ctx).textTheme.bodyLarge, textAlign: textAlign, maxLines: maxLines, overflow: overflow);

  factory UiText.bodyMedium(String text, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) =>
    UiText(text, styleBuilder: (ctx) => Theme.of(ctx).textTheme.bodyMedium, textAlign: textAlign, maxLines: maxLines, overflow: overflow);

  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      style: styleBuilder?.call(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
