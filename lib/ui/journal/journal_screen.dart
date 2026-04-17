import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/journal/list/journal_list.dart';
import 'package:portmone_bloc/ui/journal/search/journal_search_field.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class JournalScreen extends StatelessWidget {

  final FocusNode searchFocusNode;

  const JournalScreen({super.key, required this.searchFocusNode});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          titleSpacing: 0,
          pinned: true,
          scrolledUnderElevation: 0,
          backgroundColor: context.colorScheme.surfaceContainer,
          title: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: JournalSearchField(focusNode: searchFocusNode),
          ),
        ),
        JournalItemList(searchFocusNode: searchFocusNode)
      ],
    );
  }
  
}