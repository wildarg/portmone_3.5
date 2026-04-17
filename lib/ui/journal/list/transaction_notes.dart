import 'package:flutter/material.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class TransactionNotes extends StatelessWidget {
  
  final ValueChanged<String>? onTagTap;

  TransactionNotes(
    this.text, {
    super.key, 
    this.onTagTap,
  })
    : parts = text.splitHashTags;
  
  final String text;
  final List<String> parts;
  
  @override
  Widget build(BuildContext context) {
    return parts.isEmpty ? Container() : RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: <InlineSpan>[
            ..._getSpans(context)
          ]
        )
    );
  }

  List<InlineSpan> _getSpans(BuildContext context) => 
    parts.map((e) => _getSpan(e, context)).toList();

  InlineSpan _getSpan(String text, BuildContext context) =>
      text.startsWith("#") ? 
        WidgetSpan(
          child: InkWell(
            onTap: () {
              onTagTap?.call(text);
            },
            child: Text(text, style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.primary))
          )
        )
        : WidgetSpan(child: Text(text, style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurface)));

}