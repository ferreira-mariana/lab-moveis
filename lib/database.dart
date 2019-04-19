import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user.dart';

class DBProvider {
  
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
    return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
 
  DBProvider._();
  static final DBProvider db = DBProvider._();

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return await openDatabase(
    join(documentsDirectory.path, 'app_database.db'),
    onOpen: (db){},
    version: 1,
    onCreate: (db, version){
      db.execute(
        "CREATE TABLE users("
          "name TEXT PRIMARY KEY,"
          "password TEXT"
        ");" 
      );
      return db.execute("INSERT INTO users(name, password) VALUES "
          "('marcelo', '1234'),"
          "('lucas', '5678'),"
          "('mari', 'abcd'),"
          "('daianny', 'efgh'),"
          "('bruno', 'ijkl');" 
        );
    },
    );
  }
  newUser(User newUser) async{
    final db = await database;
    var res = await db.rawInsert(
      "INSERT INTO users (name, password)"
      "VALUES (${newUser.name}, ${newUser.password})"
    );
    return res;

  }

  getUser(String name) async{
    final db = await database;
    var res = await db.query("users", where: "name = ?", whereArgs: [name]);
    return res.isNotEmpty ? User.fromMap(res.first) : Null;
  }

  Future<List<User>> getAllUsers() async{
    final db = await database;
    var res = await db.rawQuery(
      "SELECT * FROM users;"
      );
    print(res.length);
    List<User> list = res.isNotEmpty ? res.map((usr) => User.fromMap(usr)).toList() : [];
    return list;
  }
  
}

