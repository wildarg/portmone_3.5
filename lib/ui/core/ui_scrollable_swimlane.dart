import 'package:flutter/material.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class UiScrollableSwimlane extends StatelessWidget {
  final String? title;
  final List<Widget> items;
  final double? height;

  const UiScrollableSwimlane({
    this.items = const [],
    this.title,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(title!, style: context.textTheme.bodyMedium),
            ),
          SizedBox(
            height: height ?? 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}
