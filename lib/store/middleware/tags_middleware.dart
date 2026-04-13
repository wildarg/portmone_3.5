import 'package:portmone_bloc/data/repo/tags_repo.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';

Middleware tagsMiddlware(TagsRepo repo) => (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {

  if (action is InitAction) {
    Future(() async {
      final tags = (await repo.getAll()).toList();
      store.dispatch(SetTagsAction(tags));
    });
  }

  return next(action);
};