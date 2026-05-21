import 'package:flutter/material.dart';

class CustomAutocompleteOptionsView<T extends Object> extends StatelessWidget {
  const CustomAutocompleteOptionsView({
    super.key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
    required this.maxOptionWidth,
  });

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;
  final double maxOptionsHeight;
  final double maxOptionWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxOptionsHeight,
            maxWidth: maxOptionWidth,
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            shrinkWrap: true,
            itemCount: options.length + 3,
            itemBuilder: (BuildContext context, int index) {
              final T option;
              if (index >= options.length) {
                return Container(height: 16);
              }
              option = options.elementAt(index);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    onSelected(option);
                  },
                  child: Builder(
                    builder: (BuildContext context) {
                      // final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                      // if (highlight) {
                      //   SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                      //     Scrollable.ensureVisible(context, alignment: 0.5);
                      //   });
                      // }
                      return Container(
                        decoration: BoxDecoration(
                          // color: highlight ? Theme.of(context).focusColor : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // color:
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(displayStringForOption(option)),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
