import 'dart:convert';

import 'package:lol_master_app/services/api/lol_api.dart';

void main() async {
  await LolApi.instance.readClientInfo();
  //果冻橙橙#91998
  var data = await LolApi.instance.queryPuuidByAlias("果冻橙橙","91998");
  print('${jsonEncode(data)}');
}
