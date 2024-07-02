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
    _database = await openDatabase(
      path,
      version: 6,
      onCreate: (Database db, int version) async {
        await createRuneTable(db);
        await createEquipTable(db);
        await createLolConfigTable(db);
        await createStatisticStandardGroup(db);
        await createStatisticStandardItem(db);
        await createStatisticStandardRecord(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await createRuneTable(db);
        await createEquipTable(db);
        await createLolConfigTable(db);
        await createStatisticStandardGroup(db);
        await createStatisticStandardItem(db);
        await createStatisticStandardRecord(db);
      },
    );
  }

  Database get database {
    return _database!;
  }

  Future<void> createRuneTable(Database database) async {
    await database.execute(
        'CREATE TABLE IF NOT EXISTS RuneConfig'
            ' (id INTEGER PRIMARY KEY autoincrement, '
            'heroId TEXT, name TEXT, content TEXT)');
  }

  Future<void> createEquipTable(Database database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS EquipConfig '
        '(id INTEGER PRIMARY KEY autoincrement, '
        'heroId TEXT,name TEXT, content TEXT)');
  }

  Future<void> createLolConfigTable(Database database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS LolConfig '
        '(id INTEGER PRIMARY KEY autoincrement,'
        ' configId TEXT, content TEXT)');
  }

  Future<void> createStatisticStandardGroup(Database database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS StatisticStandardGroup'
        ' (id INTEGER PRIMARY KEY autoincrement, uuid TEXT, '
        'puuid TEXT, summonerId TEXT, name TEXT, createTime INTEGER,'
        ' updateTime INTEGER, selected INTEGER)');
  }

  Future<void> createStatisticStandardItem(Database database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS StatisticStandardItem'
        ' (id INTEGER PRIMARY KEY autoincrement, uuid TEXT, puuid TEXT,'
        ' summonerId TEXT, groupId INTEGER, name TEXT, type TEXT, '
        'items TEXT, createTime INTEGER, updateTime INTEGER)');
  }

  Future<void> createStatisticStandardRecord(Database database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS StatisticStandardRecord '
        '(id INTEGER PRIMARY KEY autoincrement, uuid TEXT, puuid TEXT,'
        ' summonerId TEXT, gameId TEXT, standardItemId INTEGER, value TEXT,'
        ' createTime INTEGER, updateTime INTEGER)');
  }
}
