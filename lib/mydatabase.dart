import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class mydatabaseclass {
  Database? mydb;

  Future<Database?> mydbcheck() async {
    if (mydb == null) {
      mydb = await initiatedatabase();
      return mydb;
    } else {
      return mydb;
    }
  }

  int Version = 2; // Increase the version to apply changes to the schema
  initiatedatabase() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase22.db');
    Database mydatabase1 = await openDatabase(
      databasepath,
      version: Version,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE IF NOT EXISTS 'TABLE1'(
      'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'USERNAME' TEXT NOT NULL,
      'EMAIL' TEXT NOT NULL,
      'PHONE' TEXT NOT NULL,
      'ADDRESS' TEXT NOT NULL)
       ''');
        print("Database has been created");
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // Handle schema updates here
        if (oldVersion < 2) {
          db.execute('''ALTER TABLE 'TABLE1' ADD 'USERNAME' TEXT NOT NULL''');
          db.execute('''ALTER TABLE 'TABLE1' ADD 'EMAIL' TEXT NOT NULL''');
          db.execute('''ALTER TABLE 'TABLE1' ADD 'PHONE' TEXT NOT NULL''');
          db.execute('''ALTER TABLE 'TABLE1' ADD 'ADDRESS' TEXT NOT NULL''');
        }
      },
    );
    return mydatabase1;
  }

  checking() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase22.db');
    await databaseExists(databasepath) ? print("sqflite database exists :)") : print("hard luck, sqflite  Database doesnt exist :(");
  }

  reseting() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase22.db');
    await deleteDatabase(databasepath);
  }

  reading(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawQuery(sql);
    return response;
  }

  writing(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawInsert(sql);
    return response;
  }

  deleting(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawDelete(sql);
    return response;
  }

  updating(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawUpdate(sql);
    return response;
  }
}
