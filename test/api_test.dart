import 'dart:convert';

import 'package:lol_master_app/services/api/lol_api.dart';

void main() async {
  await LolApi.instance.readClientInfo();
  var data = await LolApi.instance.queryGameDetailInfo("900183722138");
  data = await LolApi.instance.queryMatchHistory(null);
  print('${jsonEncode(data)}');
}
