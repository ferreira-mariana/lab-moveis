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
    join(documentsDirectory.path, 'app_database3.db'),
    onOpen: (db){},
    version: 1,
    onCreate: (db, version){
      db.execute(
        "CREATE TABLE users("
          "name TEXT PRIMARY KEY,"
          "password TEXT,"
          "isLoggedIn BIT"
        ");"
      );
      return db.execute("INSERT INTO users(name, password, isLoggedIn) VALUES "
          "('marcelo', '1234', 0),"
          "('lucas', '5678', 0),"
          "('mari', 'abcd', 0),"
          "('daianny', 'efgh', 0),"
          "('bruno', 'ijkl', 0);" 
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
    List<User> list = res.isNotEmpty ? res.map((usr) => User.fromMap(usr)).toList() : [];
    return list;
  }

  Future<User> getLoggedIn() async{
    final db = await database;
    var res = await db.query('users', where: "isLoggedIn = ?", whereArgs: [1]);
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  void changeLoginStatus(String name, int writeValue) async{
    final db = await database;
    //var res = await db.query("users", where: "isLoggedIn = ?", whereArgs: [0]);
    //print(res);
    //int writeValue;
    //res.first["isLoggedIn"] ? writeValue = 0 : writeValue = 1;
    await db.update("users", {'isLoggedIn' : writeValue}, where: "name = ?", whereArgs: [name]);
  }  
}

