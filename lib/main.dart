import 'package:flutter/material.dart';
import 'package:lol_master_app/routes/routes.dart';
import 'package:media_kit/media_kit.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

import 'dao/db_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  windowManager.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await MyDbFactory.instance.init();
  await windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: Size(960, 540),
        center: true,
        skipTaskbar: false,
        minimumSize: Size(800, 540),
        title: "LOL大师助手",
        backgroundColor: Colors.transparent,
        alwaysOnTop: true,
      ), () async {
    await windowManager.setAsFrameless();
    await windowManager.show();
  });
  runApp(
    MaterialApp.router(
      routerConfig: deskRouter,
      theme: ThemeData(
          fontFamily: "微软雅黑",
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            primary: Color.fromARGB(255, 243, 220, 175),
            seedColor: Color.fromARGB(255, 241, 162, 6),
            background: Color.fromARGB(255, 2, 23, 29),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: Color.fromARGB(255, 2, 23, 29),
          )),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return DragToResizeArea(
          child: Column(
            children: [
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 168, 121, 8),
                ),
              ),
              Expanded(
                  child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 139, 126, 100),
                        width: 1,
                      ),
                    ),
                    child: child,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: DragToMoveArea(
                        child: Container(
                      width: MediaQuery.of(context).size.width - 48,
                      height: 32,
                    )),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              windowManager.minimize();
                            },
                            icon: Icon(Icons.remove)),
                        IconButton(
                          onPressed: () {
                            windowManager.close();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ],
          ),
        );
      },
    ),
  );
}

