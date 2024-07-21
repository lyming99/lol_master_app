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
      version: 16,
      onCreate: (Database db, int version) async {
        await createRuneTable(db);
        await createEquipTable(db);
        await createLolConfigTable(db);
        await createStatisticStandardGroup(db);
        await createStatisticStandardItem(db);
        await createStatisticStandardRecord(db);
        await createGameRecord(db);
        await createGameRecordNote(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await createRuneTable(db);
        await createEquipTable(db);
        await createLolConfigTable(db);
        await createStatisticStandardGroup(db);
        await createStatisticStandardItem(db);
        await createStatisticStandardRecord(db);
        await createGameRecord(db);
        await createGameRecordNote(db);
      },
    );
  }

  Database get database {
    return _database!;
  }

  Future<void> createRuneTable(Database database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS RuneConfig'
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
        'items TEXT, createTime INTEGER, updateTime INTEGER,description TEXT)');
    // 增加一列，如果不存在
    database.execute('ALTER TABLE StatisticStandardItem ADD COLUMN '
        'description TEXT');
  }

  Future<void> createStatisticStandardRecord(Database database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS StatisticStandardRecord '
        '(id INTEGER PRIMARY KEY autoincrement, uuid TEXT, puuid TEXT,'
        ' summonerId TEXT, gameId TEXT, standardItemId INTEGER, value TEXT,'
        ' createTime INTEGER, updateTime INTEGER)');
  }

  Future<void> createGameRecord(Database database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS GameRecord '
        '(id INTEGER PRIMARY KEY autoincrement, gameId TEXT, gameType TEXT,'
        ' gameTime INTEGER, gameDuration INTEGER, totalDamageDealtToChampions INTEGER,'
        ' totalDamageDealtToChampionsPercent REAL, totalDamageTaken INTEGER,'
        ' totalDamageTakenPercent REAL, kills INTEGER, deaths INTEGER, assists INTEGER,'
        ' creepScore INTEGER, spell1 TEXT, spell2 TEXT, primaryRune TEXT,'
        ' secondaryRune TEXT, rankLevel1 TEXT, rankLevel2 TEXT, content TEXT,'
        'puuid TEXT,summonerId TEXT)');
  }

  Future<void> createGameRecordNote(Database database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS GameRecordNote '
        '(id INTEGER PRIMARY KEY autoincrement, gameId TEXT, content TEXT)');
  }
}
