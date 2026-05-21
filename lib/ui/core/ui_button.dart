import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

enum ButtonType {
  primary,
  primarySmall,
  flatRounded,
  secondaryRounded,
  secondary,
}

class UiButton extends StatelessWidget {
  final UiIconData? icon;
  final String? text;
  final void Function()? onTap;
  final ButtonType buttonType;
  final Color? backgroundColor;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? textColor;
  final double iconSize;
  final EdgeInsets padding;
  final EdgeInsets? margins;
  final bool isBordered;
  final double? width;
  final double? height;
  final double radius;
  final TextStyle? textStyle;

  const UiButton({
    super.key,
    required this.buttonType,
    this.backgroundColor,
    this.splashColor,
    this.highlightColor,
    this.textColor,
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
  });

  factory UiButton.primarySmall({
    UiIconData? icon,
    String? text,
    void Function()? onTap,
  }) {
    return UiButton(
      buttonType: ButtonType.primarySmall,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconSize: 20,
      icon: icon,
      text: text,
      onTap: onTap,
    );
  }

  factory UiButton.primary({
    UiIconData? icon,
    String? text,
    double? width,
    void Function()? onTap,
  }) {
    return UiButton(
      buttonType: ButtonType.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      iconSize: 24,
      width: width,
      height: 42,
      icon: icon,
      text: text,
      onTap: onTap,
    );
  }

  factory UiButton.flatRounded({
    UiIconData? icon,
    String? text,
    void Function()? onTap,
    double iconSize = 24,
    Color? textColor,
    EdgeInsets? margins,
    EdgeInsets? padding,
  }) {
    return UiButton(
      buttonType: ButtonType.flatRounded,
      backgroundColor: Colors.transparent,
      textColor: textColor,
      padding: padding ?? const EdgeInsets.all(8),
      margins: margins,
      iconSize: iconSize,
      icon: icon,
      text: text,
      onTap: onTap,
    );
  }

  factory UiButton.secondaryRounded({
    UiIconData? icon,
    String? text,
    void Function()? onTap,
  }) {
    return UiButton(
      buttonType: ButtonType.secondaryRounded,
      padding: const EdgeInsets.all(8),
      iconSize: 20,
      icon: icon,
      text: text,
      onTap: onTap,
    );
  }

  factory UiButton.secondary({
    UiIconData? icon,
    String? text,
    double? width,
    double? height,
    void Function()? onTap,
    double iconSize = 20,
    double radius = 20,
    EdgeInsets? margins,
    EdgeInsets? padding,
  }) {
    return UiButton(
      buttonType: ButtonType.secondary,
      padding: padding ?? const EdgeInsets.all(8),
      margins: margins,
      radius: radius,
      iconSize: iconSize,
      width: width,
      height: height,
      icon: icon,
      text: text,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final (bgColor, splColor, hlColor, tColor, tStyle) = switch (buttonType) {
      ButtonType.primary => (
        backgroundColor ?? context.colorScheme.primary,
        splashColor ?? context.colorScheme.onPrimary.withValues(alpha: 0.2),
        highlightColor ?? context.colorScheme.onPrimary.withValues(alpha: 0.2),
        textColor ?? context.colorScheme.onPrimary,
        textStyle,
      ),
      ButtonType.primarySmall => (
        backgroundColor ?? context.colorScheme.primary,
        splashColor ?? context.colorScheme.onPrimary.withValues(alpha: 0.2),
        highlightColor ?? context.colorScheme.onPrimary.withValues(alpha: 0.2),
        textColor ?? context.colorScheme.onPrimary,
        textStyle,
      ),
      ButtonType.flatRounded => (
        backgroundColor ?? Colors.transparent,
        splashColor ?? context.colorScheme.primary.withValues(alpha: 0.1),
        highlightColor ?? context.colorScheme.primary.withValues(alpha: 0.1),
        textColor ?? context.colorScheme.onSurface,
        textStyle,
      ),
      ButtonType.secondaryRounded => (
        backgroundColor ?? context.colorScheme.secondaryContainer,
        splashColor ??
            context.colorScheme.onSecondaryContainer.withValues(alpha: 0.1),
        highlightColor ??
            context.colorScheme.onSecondaryContainer.withValues(alpha: 0.1),
        textColor ?? context.colorScheme.onSecondaryContainer,
        textStyle,
      ),
      ButtonType.secondary => (
        backgroundColor ?? context.colorScheme.secondaryContainer,
        splashColor ??
            context.colorScheme.onSecondaryContainer.withValues(alpha: 0.1),
        highlightColor ??
            context.colorScheme.onSecondaryContainer.withValues(alpha: 0.1),
        textColor ?? context.colorScheme.onSecondaryContainer,
        textStyle,
      ),
    };

    return UnconstrainedBox(
      child: Padding(
        padding: margins ?? EdgeInsets.zero,
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            onTap: onTap,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            splashColor: splColor,
            highlightColor: hlColor,
            child: Container(
              padding: padding,
              width: width,
              height: height ?? 36,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (icon != null)
                    UiIcon(icon!, width: iconSize, color: tColor),
                  if (icon != null && text != null) const SizedBox(width: 8),
                  if (text != null)
                    Text(
                      text!,
                      style:
                          tStyle ??
                          context.textTheme.labelLarge?.copyWith(color: tColor),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
