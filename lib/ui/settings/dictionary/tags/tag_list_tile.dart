import 'package:flutter/material.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class TagListTile extends StatelessWidget {

  final String tag;

  const TagListTile({
    super.key, 
    required this.tag,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      key: ValueKey(tag),
      title: Text(
        tag,
        style: theme.textTheme.titleMedium,
      ),
      trailing: UiButton.flatRounded(
        icon: UiIcons.delete,
        onTap: () => context.dispatch(DeleteTagAction(tag)),
      ),
    );
  }  
}
