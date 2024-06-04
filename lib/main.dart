import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:lol_master_app/routes/routes.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await windowManager.ensureInitialized();
  runApp(
    MaterialApp.router(
      routerConfig: deskRouter,
      theme: ThemeData(
          fontFamily: "微软雅黑",
          colorScheme: ColorScheme.fromSeed(
            seedColor: BrnDefaultConfigUtils.defaultCommonConfig.brandPrimary,
          )),
      debugShowCheckedModeBanner: false,
    ),
  );
}
