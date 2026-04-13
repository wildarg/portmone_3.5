import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:rxdart/rxdart.dart';

class StoreBuilder<T> extends StatelessWidget {

  final BehaviorSubject<T> Function(PortmoneStore store) stream;
  final Widget Function(BuildContext context, T state) builder;

  const StoreBuilder({super.key, required this.stream, required this.builder});

  @override
  Widget build(BuildContext context) {
    final source = stream(context.read<PortmoneStore>());
    return _StoreBuilderBase(
      stream: source,
      builder: builder,
    );
  }

}

class _StoreBuilderBase<T> extends StatefulWidget {

  final BehaviorSubject<T> stream;
  final Widget Function(BuildContext context, T state) builder;

  const _StoreBuilderBase({super.key, required this.stream, required this.builder});

  @override
  State<_StoreBuilderBase<T>> createState() => _StoreBuilderBaseState<T>();
}

class _StoreBuilderBaseState<T> extends State<_StoreBuilderBase<T>> {

  late T _currentState;
  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    _currentState = widget.stream.value;
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant _StoreBuilderBase<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription = widget.stream.listen((state) => 
      setState(() {
        _currentState = state;
      })
    );
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
    return widget.builder(context, _currentState);
  }
}