import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/journal/list/journal_list_item.dart';

class JournalItemList extends StatelessWidget {

  const JournalItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      stream: (store) => store.journalState,
      builder:(context, journal) {
        return SliverList.builder(
          itemCount: journal.length,
          itemBuilder: (_, index) => JournalListItem(data: journal[index])
        );
      }  
    );
  }

  // void onDismiss(
  //   BuildContext context,
  //   Store<PortmoneState> store, 
  //   Operation operation
  // ) {
  //   final (label, deleteAction, undoAction) = switch (operation) {
  //     Expense() => ('Expense deleted', DeleteExpenseAction(operation), RestoreExpenseAction(operation)),
  //     Income() => ('Income deleted', DeleteIncomeAction(operation), RestoreIncomeAction(operation)),
  //     Transfer() => ('Transfer deleted', DeleteTransferAction(operation), RestoreTransferAction(operation)),
  //     _ => throw ArgumentError('Unknown operation')      
  //   };
  //   store.dispatch(deleteAction);
  //   final snackBar = UndoSnackbar.build(
  //     label: label,
  //     onUndo: () {
  //       store.dispatch(undoAction);
  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //     }
  //   );

  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // } 
  


}