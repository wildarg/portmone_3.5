import 'package:flutter/material.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class UiCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Color? color;
  final Color? highlightColor;
  final Color? splashColor;
  final String? title;
  final double elevation;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
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
    this.crossAxisAlignment,
    this.mainAxisAlignment,
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
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: color ?? context.colorScheme.surfaceContainer,
        child: InkWell(
          highlightColor: highlightColor,
          splashColor: splashColor,
          onTap: onTap,
          child: SizedBox(   
            width: width,
            height: height,     
            child: Column(
              crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
