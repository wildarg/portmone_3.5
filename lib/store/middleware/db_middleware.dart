import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:share_plus/share_plus.dart';

Middleware dbMiddleware(PortmoneDB db) =>
    (PortmoneStore store, PortmoneAction action, NextDispatcher next) async {
      if (action is BackupDbAction) {
        return db.backup();
      } else if (action is RestoreDbAction) {
        final isRestored = await db.restore();
        if (isRestored) store.dispatch(InitAction());
        return;
      } else {
        return next(action);
      }
    };

extension _DbExtension on PortmoneDB {
  Future<void> backup() async {
    final dbPath = await getFileNameToShareBackup();
    await SharePlus.instance.share(
      ShareParams(files: [XFile(dbPath)], text: 'Portmone Database Backup'),
    );
  }

  Future<bool> restore() async {
    final path = (await FilePicker.pickFiles())?.files.single.path;
    if (path != null) {
      try {
        final file = File(path);
        await restoreFrom(file);
        return true;
      } catch (e) {
        log('Error on restoring database: $e');
      }
    }
    return false;
  }
}
