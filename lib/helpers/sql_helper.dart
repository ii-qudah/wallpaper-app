import 'package:flutter/foundation.dart';
// import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper extends ChangeNotifier {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initalDb();
      return _db;
    } else {
      return _db;
    }
  }

  initalDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'wallpaper.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 4, onUpgrade: _onUpgrade);
    notifyListeners();
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade===========");
  }

  _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE wallpaper (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      url TEXT NOT NULL,
      key TEXT NOT NULL,
      photographer TEXT NOT NULL
      )
      ''');
    notifyListeners();
    print("Create wallpaper DATABASE");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    notifyListeners();
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    notifyListeners();
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    notifyListeners();
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    notifyListeners();
    return response;
  }

  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'wallpaper.db');
    notifyListeners();
    await deleteDatabase(path);
  }

  Future<bool> checkExists(String url) async {
    final mydb = await db;
    var response =
        await mydb!.rawQuery("SELECT * FROM wallpaper WHERE url = '$url'");
    notifyListeners();
    return response.isNotEmpty;
  }
}
