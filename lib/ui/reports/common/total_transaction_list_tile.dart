import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/currency_info.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';
import 'package:rxdart/rxdart.dart';

class TotalTransactionListTile extends StatelessWidget {

  final BehaviorSubject<List<CurrencyInfo>> Function(PortmoneStore store) streamBuilder;

  const TotalTransactionListTile({super.key, required this.streamBuilder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StoreBuilder(
        stream: streamBuilder,
        builder:(context, state) => RichText(
          text: TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text('Total: ', style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              ...state.map((info) => 
                WidgetSpan(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      Text(info.currency.name, style: TextStyle(color: context.colorScheme.primary)),
                      const SizedBox(width: 4),
                      Text(info.amount.formattedAmount, style: context.textTheme.labelLarge),
                    ],
                  )
                )
              )
            ]
          )
        ),
      ),
    );
  }

}
