import 'package:flutter/material.dart';
import 'ui_icon.dart';

enum UiButtonType { primarySmall, primary, flatRounded, secondaryRounded, secondary, custom }

class UiButton extends StatelessWidget {
  final UiIconData? icon;
  final String? text;
  final void Function()? onTap;
  
  final UiButtonType _type;

  final Color? backgroundColor;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? textColor;
  final double? iconSize;
  final EdgeInsets? padding;
  final EdgeInsets? margins;
  final bool isBordered;
  final double? width;
  final double? height;
  final double radius;
  final TextStyle? textStyle;

  const UiButton({
    super.key,
    required this.backgroundColor,
    required this.splashColor,
    required this.highlightColor,
    required this.textColor,
    required this.iconSize,
    required this.padding,
    this.margins,
    this.isBordered = false,
    this.radius = 20,
    this.height,
    this.width,
    this.icon,
    this.text,
    this.onTap,
    this.textStyle,
  }) : _type = UiButtonType.custom;

  const UiButton.primarySmall({
    super.key,
    this.icon,
    this.text,
    this.onTap,
    this.margins,
  })  : _type = UiButtonType.primarySmall, backgroundColor = null, splashColor = null, highlightColor = null, textColor = null, iconSize = null, padding = null, isBordered = false, radius = 20, height = null, width = null, textStyle = null;

  const UiButton.primary({
    super.key,
    this.icon,
    this.text,
    this.width,
    this.onTap,
    this.margins,
  }) : _type = UiButtonType.primary, backgroundColor = null, splashColor = null, highlightColor = null, textColor = null, iconSize = null, padding = null, isBordered = false, radius = 20, height = null, textStyle = null;

  const UiButton.flatRounded({
    super.key,
    this.icon,
    this.text,
    this.onTap,
    this.iconSize = 24,
    this.textColor,
    this.margins,
    this.padding,
  }) : _type = UiButtonType.flatRounded, backgroundColor = null, splashColor = null, highlightColor = null, isBordered = false, radius = 20, height = null, width = null, textStyle = null;

  const UiButton.secondaryRounded({
    super.key,
    this.icon,
    this.text,
    this.onTap,
    this.margins,
  }) : _type = UiButtonType.secondaryRounded, backgroundColor = null, splashColor = null, highlightColor = null, textColor = null, iconSize = null, padding = null, isBordered = false, radius = 20, height = null, width = null, textStyle = null;

  const UiButton.secondary({
    super.key,
    this.icon,
    this.text,
    this.width,
    this.height,
    this.onTap,
    this.iconSize = 20,
    this.radius = 20,
    this.margins,
    this.padding,
  }) : _type = UiButtonType.secondary, backgroundColor = null, splashColor = null, highlightColor = null, textColor = null, isBordered = false, textStyle = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color bg;
    Color spl;
    Color hlt;
    Color fg;
    double iSize;
    EdgeInsets pd;
    double h = height ?? 36;
    TextStyle? tStyle;

    switch (_type) {
      case UiButtonType.primarySmall:
        bg = colorScheme.primary;
        spl = colorScheme.onPrimary.withValues(alpha: 0.2);
        hlt = colorScheme.onPrimary.withValues(alpha: 0.2);
        fg = colorScheme.onPrimary;
        pd = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        iSize = 20;
        break;
      case UiButtonType.primary:
        bg = colorScheme.primary;
        spl = colorScheme.onPrimary.withValues(alpha: 0.2);
        hlt = colorScheme.onPrimary.withValues(alpha: 0.2);
        fg = colorScheme.onPrimary;
        pd = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
        iSize = 24;
        h = 42;
        tStyle = textTheme.labelLarge?.copyWith(color: fg, fontWeight: FontWeight.bold);
        break;
      case UiButtonType.flatRounded:
        bg = Colors.transparent;
        spl = colorScheme.primary.withValues(alpha: 0.1);
        hlt = colorScheme.primary.withValues(alpha: 0.1);
        fg = textColor ?? colorScheme.onSurface;
        pd = padding ?? const EdgeInsets.all(8);
        iSize = iconSize ?? 24;
        break;
      case UiButtonType.secondaryRounded:
        bg = colorScheme.secondaryContainer;
        spl = colorScheme.onSecondaryContainer.withValues(alpha: 0.1);
        hlt = colorScheme.onSecondaryContainer.withValues(alpha: 0.1);
        fg = colorScheme.onSecondaryContainer;
        pd = const EdgeInsets.all(8);
        iSize = 20;
        break;
      case UiButtonType.secondary:
        bg = colorScheme.secondaryContainer;
        spl = colorScheme.onSecondaryContainer.withValues(alpha: 0.1);
        hlt = colorScheme.onSecondaryContainer.withValues(alpha: 0.1);
        fg = colorScheme.onSecondaryContainer;
        pd = padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        iSize = iconSize ?? 20;
        tStyle = textTheme.labelLarge?.copyWith(color: fg, fontWeight: FontWeight.bold);
        break;
      case UiButtonType.custom:
        bg = backgroundColor!;
        spl = splashColor!;
        hlt = highlightColor!;
        fg = textColor!;
        pd = padding!;
        iSize = iconSize!;
        tStyle = textStyle;
        break;
    }

    return Padding(
      padding: margins ?? EdgeInsets.zero,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          splashColor: spl,
          highlightColor: hlt,
          child: Container(
            padding: pd,
            width: width,
            height: h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (icon != null) UiIcon(icon!, width: iSize, color: fg),
                if (icon != null && text != null) const SizedBox(width: 8),
                if (text != null)
                  Text(
                    text!,
                    style: tStyle ?? textTheme.labelLarge?.copyWith(color: fg),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
