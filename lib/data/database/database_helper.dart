import 'package:godeye_parser/domain/domain.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

abstract class DBConsts {
  static const fileSearchTable = 'fileSearch';
  static const fileId = 'fileSearchId';
  static const name = 'nameControllerText';
  static const city = 'cityControllerText';
  static const experience = 'experienceControllerText';

  static const textSearchTable = 'textSearch';
  static const textId = 'textSearchId';
  static const text = 'controllerText';

  static const region = 'regionToSearch';
}

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  static const _databaseName = 'godEyeParserData.db';
  static const _databaseVersion = 1;

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = p.join(documentsDirectory.path, 'goeEyeData', _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<Database> get database async =>
      _database != null ? _database! : await _initDatabase();

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${DBConsts.fileSearchTable} (
            ${DBConsts.fileId} INTEGER PRIMARY KEY,
            ${DBConsts.region} TEXT NOT NULL,
	          ${DBConsts.name} TEXT NOT NULL,
	          ${DBConsts.city} TEXT NOT NULL,
	          ${DBConsts.experience} TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE ${DBConsts.textSearchTable} (
	          ${DBConsts.textId} INTEGER PRIMARY KEY DEFAULT 0,
	          ${DBConsts.region} TEXT NOT NULL,
	          ${DBConsts.text} TEXT NOT NULL
          );
          ''');
  }

  void close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> fillDatabases(bool fillTextDb) async {
    final db = await instance.database;
    await db.rawDelete('DELETE FROM ${DBConsts.fileSearchTable}');
    await db.rawInsert('''
          INSERT INTO ${DBConsts.fileSearchTable} VALUES
            (0 ,'', '', '', ''),
            (1 ,'', '', '', ''),
            (2 ,'', '', '', ''),
            (3 ,'', '', '', ''),
            (4 ,'', '', '', '');
          ''');
    if (fillTextDb) {
      await db.rawDelete('DELETE FROM ${DBConsts.textSearchTable}');
      await db.rawInsert('''
          INSERT INTO ${DBConsts.textSearchTable} VALUES
            (0 ,'', '');
          ''');
    }
  }

  Future<bool> tablesAreEmpty() async {
    final isFileDbEmpty = await getFileDbLastId() == -1;
    final isTextDbEmpty = await getTextDbLastId() == -1;
    if (isFileDbEmpty || isTextDbEmpty) return true;
    return false;
  }

  Future<void> insertItemsToList(int count) async {
    final db = await instance.database;

    for (int i = 1; i <= count; i++) {
      final lastId = await getFileDbLastId();
      db.rawInsert('''
          INSERT INTO ${DBConsts.fileSearchTable} VALUES
          (${lastId + 1}, '', '', '', '');
       ''');
    }
  }

  Future<int> getFileDbLastId() async {
    final db = await instance.database;
    final query = await db.rawQuery(
        'SELECT(MAX(${DBConsts.fileId})) as max_id FROM ${DBConsts.fileSearchTable}');
    final maxId = query.first['max_id'];
    return maxId == null ? -1 : maxId as int;
  }

  Future<int> getTextDbLastId() async {
    final db = await instance.database;
    final query = await db.rawQuery(
        'SELECT(MAX(${DBConsts.textId})) as max_id FROM ${DBConsts.textSearchTable}');
    final maxId = query.first['max_id'];
    return maxId == null ? -1 : maxId as int;
  }

  Future<void> updateRegion(String newValue, {int? index}) async {
    final db = await instance.database;
    if (index == null) {
      db.rawUpdate(
          "UPDATE ${DBConsts.textSearchTable} SET ${DBConsts.region} = '$newValue';");
    } else {
      db.rawUpdate('''
         UPDATE ${DBConsts.fileSearchTable}
         SET ${DBConsts.region} = '$newValue'
         WHERE ${DBConsts.fileId} = $index
      ''');
    }
  }

  Future<void> updateValue(String type, String newValue, int index) async {
    final db = await instance.database;
    await db.rawUpdate('''
          UPDATE ${DBConsts.fileSearchTable}
          SET $type = '$newValue'
          WHERE ${DBConsts.fileId} = $index
    ''');
  }

  Future<void> updateText(String newValue) async {
    final db = await instance.database;
    await db.rawUpdate('''
          UPDATE ${DBConsts.textSearchTable}
          SET ${DBConsts.text} = '$newValue'
    ''');
  }

  Future<void> clearItem(int index) async {
    final db = await instance.database;
    await db.rawUpdate('''
          UPDATE ${DBConsts.fileSearchTable}
          SET (${DBConsts.fileId}, ${DBConsts.region}, ${DBConsts.name}, ${DBConsts.city}, ${DBConsts.experience})
	            = ($index, '', '', '', '')
          WHERE ${DBConsts.fileId} = $index;
       ''');
  }

  Future<FileSearchData> selectFileItem(int index) async {
    final db = await instance.database;
    final query = await db.rawQuery(
        'SELECT * FROM ${DBConsts.fileSearchTable} WHERE ${DBConsts.fileId} = $index;');
    return FileSearchData.fromJson(query[0]);
  }

  Future<TextSearchData> selectTextItem() async {
    final db = await instance.database;
    final query =
        await db.rawQuery('SELECT * FROM ${DBConsts.textSearchTable}');
    return TextSearchData.fromJson(query[0]);
  }

  Future<List<FileSearchData>> selectFileList() async {
    final db = await instance.database;
    final query =
        await db.rawQuery('SELECT * FROM ${DBConsts.fileSearchTable}');
    final fileList = <FileSearchData>[];
    for (var item in query) {
      fileList.add(FileSearchData.fromJson(item));
    }
    return fileList;
  }
}
