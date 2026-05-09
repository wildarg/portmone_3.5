import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:portmone_bloc/utils/list_extensions.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBHelper {

  final String name;
  final int version;

  List<String> get scheme;
  Map<int, Future<void> Function(Database db)> get upgradeMap => {};

  DBHelper({required this.name, required this.version});
  Database? _instance;

  Future<Database> getDb() async {
    return _instance ??= await _openDb();
  }

  Future<Database> _openDb() async {
    String path = await _getDBPath();
    return openDatabase(
      path, 
      version: version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
  }

  Future<String> _getDBPath() async {
    return p.join(await getDatabasesPath(), name);
  }

  Future<void> _onCreate(Database db, int version) {
    return Future.forEach(scheme, db.execute);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final Iterable<Future<void> Function(Database db)> upgradeCallbacks = upgradeMap.entries
        .where((e) => oldVersion < e.key)
        .sortWith(_upgradeEntriesComparator)
        .map((e) => e.value);

    await Future.forEach(upgradeCallbacks, (f) async { await f(db); });
  }

  int _upgradeEntriesComparator(
    MapEntry<int, Future<void> Function(Database db)> first,
    MapEntry<int, Future<void> Function(Database db)> second,    
  ) {
    return first.key.compareTo(second.key);
  }

  Future<String> getFileNameToShareBackup() async {
    Database db = await getDb();
    db.close();
    _instance = null;
    String path = await _getDBPath();
    File backup = await File(path).copy(path.replaceAll('databases', 'files'));
    return backup.path;
  }

  Future<void> restoreFrom(File file) async {
    Database db = await getDb();
    db.close();
    _instance = null;
    await file.copy(await _getDBPath());
  }

  Future<List<Map<String, Object?>>> query(String sql) async {
    Database db = await getDb();
    return db.rawQuery(sql);
  }

  Future<void> delete(String table, {String? where, List<dynamic>? args}) async {
    Database db = await getDb();
    await db.delete(table, where: where, whereArgs: args);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    Database db = await getDb();
    return db.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> batchInsert(String table, Iterable<Map<String, dynamic>> values) async {
    Database db = await getDb();
    Batch batch = db.batch();
    for (var map in values) { 
      batch.insert(table, map, conflictAlgorithm: ConflictAlgorithm.ignore); 
    }
    await batch.commit();
  }

  Future<T> batch<T>(Future<T> Function(Batch batch) block) async {
    Database db = await getDb();
    Batch batch = db.batch();
    T result = await block(batch);
    await batch.commit();
    return result;
  }

  Future<void> exec(List<String> script) async {
    Database db = await getDb();
    return db.exec(script);
  }

  Future<void> transaction<T>(Future<T> Function(TransactionHelper t) action) async {
    Database db = await getDb();    
    return db.transaction((txn) async {
      final helper = TransactionHelper(txn);
      await action(helper);
    });
  }

}

class TransactionHelper {
  final Transaction txn;

  TransactionHelper(this.txn);

  Future<void> delete(String table, {String? where, List<dynamic>? args}) async {
    await txn.delete(table, where: where, whereArgs: args);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    return txn.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> batchInsert(String table, Iterable<Map<String, dynamic>> values) async {
    Batch batch = txn.batch();
    for (var map in values) { 
      batch.insert(table, map, conflictAlgorithm: ConflictAlgorithm.ignore); 
    }
    await batch.commit();
  }

}

extension DatabaseExtension on Database {

  Future<void> exec(List<String> script) {
    return transaction((txn) async {
      Future.forEach(script, txn.execute);
    });
  }

}