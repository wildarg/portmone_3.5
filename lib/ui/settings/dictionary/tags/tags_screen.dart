import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/ui/settings/dictionary/tags/tag_list_tile.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TagsScreenState();
  }
  
}

class _TagsScreenState extends State<TagsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: UiButton.flatRounded(
          icon: UiIcons.arrowBack,
          onTap: () => context.pop(),
        ),
        title: Text('Tags'),        
      ),
      body: StoreBuilder(
        stream: (store) => store.tagsState,
        builder:(context, state) {
          return CustomScrollView(
            slivers: [
              SliverList.builder(     
                itemCount: state.length,       
                itemBuilder:(context, index) => TagListTile(tag: state[index])
              )
            ],
          );
        }
      ),
    );
  }

}
