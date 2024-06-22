import 'package:sqflite/sqflite.dart';

class MyDbFactory {
  MyDbFactory._internal();

  static MyDbFactory? _instance;

  static MyDbFactory get instance {
    _instance ??= MyDbFactory._internal();
    return _instance!;
  }

  Database? _database;

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/lol.db';
    await deleteDatabase(path);
    _database = await openDatabase(
      path,
      version: 3,
      onCreate: (Database db, int version) async {
        await createRuneTable(db);
        await createEquipTable(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion <= 2) {
          await createEquipTable(db);
        }
      },
    );
  }

  Database get database {
    return _database!;
  }

  Future<void> createRuneTable(Database database) async {
    await database.execute(
        'CREATE TABLE RuneConfig (id INTEGER PRIMARY KEY autoincrement, heroId TEXT, name TEXT, content TEXT)');
  }

  Future<void> createEquipTable(Database database) async {
    await database.execute(
        'CREATE TABLE EquipConfig (id INTEGER PRIMARY KEY autoincrement, heroId TEXT,name TEXT, content TEXT)');
  }
}
