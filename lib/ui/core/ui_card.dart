import 'package:flutter/material.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class UiCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Color? color;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? strokeColor;
  final double? strokeWidth;
  final String? title;
  final double elevation;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const UiCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.highlightColor,
    this.splashColor,
    this.strokeColor,
    this.strokeWidth,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.title,
    this.onTap,
    this.elevation = 0,
    this.margin = EdgeInsets.zero,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: color ?? context.colorScheme.surfaceContainer,
        child: InkWell(
          highlightColor: highlightColor,
          splashColor: splashColor,
          onTap: onTap,
          child: Container(   
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: strokeWidth != null
                  ? Border.all(
                      color: strokeColor ?? context.colorScheme.outline,
                      width: strokeWidth!,
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              mainAxisSize: mainAxisSize ?? MainAxisSize.min,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, right: 16.0, bottom: 8.0),
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                if (padding != null)
                  Padding(
                    padding: padding!,
                    child: child,
                  )
                else
                  child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
