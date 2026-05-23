import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/account_ranged_info.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/reports/accounts/account_balance_item.dart';

class AccountBalanceSwimlane extends StatelessWidget {
  const AccountBalanceSwimlane({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StoreBuilder(
        stream: (store) => store.accountBalanceState,
        builder: (context, state) => _DraggableAccountCards(
          data: state,
          onTap: (account) => context.dispatch(SetAccountFilterAction(account)),
        ),
      ),
    );
  }
}

class _DraggableAccountCards extends StatefulWidget {
  final List<AccountRangedInfo> data;
  final void Function(Account account) onTap;

  const _DraggableAccountCards({required this.data, required this.onTap});

  @override
  _DraggableCardsState createState() => _DraggableCardsState();
}

class _DraggableCardsState extends State<_DraggableAccountCards> {
  late List<AccountRangedInfo> items;

  @override
  void initState() {
    super.initState();
    items = widget.data.toList();
  }

  @override
  void didUpdateWidget(covariant _DraggableAccountCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        items = widget.data.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
          final orderedList = items.map((e) => e.account).toList();
          context.dispatch(SetAccountOrderAction(orderedList));
        });
      },
      proxyDecorator: (Widget child, int index, Animation<double> animation) {
        return Material(
          elevation: 8, // give shadow while dragging
          color: Colors.transparent,
          child: Opacity(
            opacity: 1,
            child: Transform.scale(
              scale: 1.05, // slightly bigger when dragging
              child: child,
            ),
          ),
        );
      },
      itemBuilder: (context, index) {
        final item = items[index];
        return RangedAccountListTile(
          key: ValueKey(item),
          info: item,
          onTap: () => widget.onTap(item.account),
        );
      },
    );
  }
}
