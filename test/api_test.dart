
import 'dart:convert';

import 'package:lol_master_app/services/api/lol_api.dart';

void main() async {
  await LolApi.instance.readClientInfo();
  var resp = await LolApi.instance.querySummonerInfoByPuuid("3ee718c8-d5c0-550f-bfed-0489d6729438");
  print(jsonEncode(resp));
}
