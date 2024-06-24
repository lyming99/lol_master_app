import 'package:lol_master_app/services/api/lol_api.dart';

void main() async {
  await LolApi.instance.readClientInfo();
  var data = LolApi.instance.getAccountInfo();
  print('${data?.profileIconId}');
}
