import 'package:flutter/material.dart';
import 'package:lol_master_app/util/mvc.dart';

/// 英雄符文控制器
class DeskHeroRuneController extends MvcController {


  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {

  }


}
