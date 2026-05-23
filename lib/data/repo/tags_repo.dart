import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/library_queries.dart';
import 'package:portmone_bloc/data/db/scheme.dart';

class TagsRepo {
  final PortmoneDB db;

  TagsRepo({required this.db});

  Future<Iterable<String>> getAll() {
    return GetAllTagsQuery(db).execute();
  }

  Future<String?> getByName(String name) async => (await db.query(
    "select * from ${TagsTable.tableName} where ${TagsTable.name} = '$name'",
  )).map(_fromMap).firstOrNull;

  Future<void> delete(String tag) async {
    await db.delete(TagsTable.tableName, where: "${TagsTable.name} = '$tag'");
  }

  Future<String> put(String tag) async {
    await db.insert(TagsTable.tableName, _toMap(tag));
    return tag;
  }

  Future<List<String>> putTags(List<String> tags) async {
    await db.batchInsert(TagsTable.tableName, tags.map(_toMap));
    return tags;
  }

  String _fromMap(Map<String, dynamic> map) {
    return map[TagsTable.name];
  }

  Map<String, dynamic> _toMap(String tag) {
    return {TagsTable.name: tag};
  }
}
