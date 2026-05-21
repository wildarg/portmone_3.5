import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/amount_type_info.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/reports/common/type_amount_list_tile.dart';
import 'package:rxdart/rxdart.dart';

class TypedTransactionSheet extends StatelessWidget {
  final BehaviorSubject<List<AmountTypeInfo>> Function(PortmoneStore store)
  streamBuilder;
  final bool isExpense;

  const TypedTransactionSheet({
    super.key,
    required this.streamBuilder,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: StoreBuilder(
        stream: streamBuilder,
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: state
              .map((e) => TypeAmountListTile(data: e, isExpense: isExpense))
              .toList(),
        ),
      ),
    );
  }
}
