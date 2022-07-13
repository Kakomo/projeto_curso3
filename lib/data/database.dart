import 'package:nosso_primeiro_projeto/data/task_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//iniciando o banco de dados
Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'task1.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(TaskDao.tableSql);
    },
    version: 1,
  );
}
