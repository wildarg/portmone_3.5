import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/journal/list/journal_list_item.dart';

class JournalItemList extends StatelessWidget {
  
  final FocusNode? searchFocusNode;

  const JournalItemList({super.key, this.searchFocusNode});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      stream: (store) => store.journalState,
      builder:(context, journal) {
        return SliverList.builder(
          itemCount: journal.length,
          itemBuilder: (_, index) => JournalListItem(
            data: journal[index],
            onOpenEditor: () => searchFocusNode?.unfocus(),
          )
        );
      }  
    );
  }

}