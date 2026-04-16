import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/ui/core/expandable_fab.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class FabController extends ChangeNotifier {

  bool _isShown = false;
  bool get isShown => _isShown;

  void show() {
    _isShown = true;
    notifyListeners();
  }

  void hide() {
    _isShown = false;
    notifyListeners();
  }
}

class SlidableFab extends StatefulWidget {

  final FabController controller;

  const SlidableFab({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() {
    return _SlidableFabState();
  }
  
}

class _SlidableFabState extends State<SlidableFab> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  bool _isShown = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(value: 0.0, vsync: this);
    _subscribe(widget.controller);
    _isShown = widget.controller.isShown;
  }

  @override
  void didUpdateWidget(covariant SlidableFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _unsubscribe(oldWidget.controller);
      _subscribe(widget.controller);
      _handleControllerChange();      
    }
  }

  void _subscribe(FabController controller) {
    controller.addListener(_handleControllerChange);
  }

  void _unsubscribe(FabController controller) {
    controller.removeListener(_handleControllerChange);
  }

  void _handleControllerChange() {
    if (_isShown != widget.controller.isShown) {
      if (widget.controller.isShown) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    _isShown = widget.controller.isShown;
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
        initialOpen: false,
        distance: 150,
        buttons: [          
          ActionButtonData(
            onPressed: () => context.push('/transfer/editor'),
            icon: UiIcons.currencyExchange,
          ),
          ActionButtonData(
            onPressed: () => context.push('/income/editor'),
            icon: UiIcons.wallet,
          ),
          ActionButtonData(
            onPressed: () => context.push('/expense/editor'),
            icon: UiIcons.receipt,
          ),
        ],  
      )
        .animate(controller: _controller, autoPlay: false)
        .slideX(
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 500),
          begin: 100,
          end: 0
        );    
  }

}