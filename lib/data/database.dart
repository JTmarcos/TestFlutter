import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:test/data/task_dao.dart';

Future<Database> getDataBase() async {
  final String path = join(await getDatabasesPath(), "Task.db");
  return openDatabase(
    path,
    onCreate: ((db, version) => db.execute(TaskDao.tableSQL)),
    version: 1,
  );
}

