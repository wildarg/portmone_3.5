import 'package:flutter/material.dart';

class FocusNodeGroup {
  final int count;
  final List<FocusNode> _nodes;

  FocusNodeGroup(this.count) : _nodes = List.generate(count, (ind) => FocusNode());
  
  FocusNode operator [](int i) => _nodes[i]; 

  void dispose() {
    for (var e in _nodes) {
      e.dispose();
    }
  }

  void unfocus() {
    for (var e in _nodes) {
      if (e.hasFocus) {
        e.unfocus();
      }
    }
  }

  bool get hasFocus {
    return _nodes.any((e) => e.hasFocus);
  }
}