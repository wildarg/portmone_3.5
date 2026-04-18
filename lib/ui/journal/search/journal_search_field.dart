import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/core/ui_text_field.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:rxdart/rxdart.dart';

class JournalSearchField extends StatefulWidget {

  final FocusNode? focusNode;

  const JournalSearchField({super.key, this.focusNode});

  @override
  State<JournalSearchField> createState() => _JournalSearchFieldState();
}

class _JournalSearchFieldState extends State<JournalSearchField> with SingleTickerProviderStateMixin {

  final StreamController<VoidCallback> _controller = StreamController();
  late AnimationController _clearButtonAnimation;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.stream
      .debounceTime(const Duration(milliseconds: 300))
      .listen((action) => action.call());
    _clearButtonAnimation = AnimationController(vsync: this, duration: Durations.medium1);
    _textController.text = context.store.filterState.value.text;
    Future.delayed(Durations.medium1, (){
      if (_textController.text.isNotEmpty) {
        _clearButtonAnimation.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return UiTextField(
      controller: _textController,
      leadingIcon: UiIcon(UiIcons.search),
      focusNode: widget.focusNode,
      trailingIcon: UnconstrainedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiButton.flatRounded(
              icon: UiIcons.receipt2,
              iconSize: 16,
              textColor: context.colorScheme.primary,
              onTap: () {
                showModalBottomSheet(
                  context: context, 
                  builder:(context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)
                        )
                      ),
                      height: 200,
                      padding: const EdgeInsets.all(24),
                      child: Container(),
                      // TODO: amount widget
                      // child: TotalAmountWidget(
                      //   state: store.state,
                      //   onClose: context.pop  
                      // ),
                    );
                  },
                );
              },
            ),
            SizedBox(width: 8),
            UiButton.flatRounded(
              icon: UiIcons.close,
              iconSize: 16,
              onTap: () {
                widget.focusNode?.unfocus();
                _textController.clear();
                context.dispatch(SetTextFilterAction(''));
                _clearButtonAnimation.reverse();
              },
            ),
          ],
        )
      ).animate(controller: _clearButtonAnimation, autoPlay: false)
          .scale(),
      constraints: const BoxConstraints.tightFor(height: 38),
      onChanged: (value) {
        if (value.isNotEmpty) {
          _clearButtonAnimation.forward();
        } else {
          _clearButtonAnimation.reverse();
        }
        _controller.sink
          .add(() {
            context.dispatch(SetTextFilterAction(value));
          });
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    _clearButtonAnimation.dispose();
    super.dispose();
  }

}