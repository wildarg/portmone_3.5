import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:rxdart/rxdart.dart';

class StoreListener<T> extends StatelessWidget {

  final BehaviorSubject<T> Function(PortmoneStore store) stream;
  final void Function(T state) onState;
  final Widget child;

  const StoreListener({super.key, required this.stream, required this.onState, required this.child});

  @override
  Widget build(BuildContext context) {
    final source = stream(context.read<PortmoneStore>());
    return _StoreListenerBase(
      stream: source,
      onState: onState,
      child: child,
    );
  }

}

class _StoreListenerBase<T> extends StatefulWidget {

  final BehaviorSubject<T> stream;
  final Widget child;
  final void Function(T state) onState;

  const _StoreListenerBase({super.key, required this.stream, required this.child, required this.onState});

  @override
  State<_StoreListenerBase<T>> createState() => _StoreListenerBaseState<T>();
}

class _StoreListenerBaseState<T> extends State<_StoreListenerBase<T>> {

  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant _StoreListenerBase<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription = widget.stream.listen(widget.onState);
  }

  void _unsubscribe() {
    _subscription?.cancel();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}