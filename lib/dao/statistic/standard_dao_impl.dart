import 'dart:convert';

import 'package:lol_master_app/entities/rune/rune.dart';

import 'standard_dao.dart';


// 1.创建数据库连接(即打开数据库sqlite文件)
// 2.创建表
// 3.用连接进行增删改查
class StandardDaoImpl extends StandardDao {
  StandardDaoImpl({
    required super.database,
  });

}
