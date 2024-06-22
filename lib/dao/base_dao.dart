import 'package:sqflite/sqflite.dart';

abstract class BaseDao{
  Database database;

  BaseDao({
    required this.database,
  });
}