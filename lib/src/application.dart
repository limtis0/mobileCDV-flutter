import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_cdv/src/logic/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_cdv/src/logic/globals.dart' as globals;
import 'static.dart';

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, ThemeModel notifier, child){
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: notifier.setTheme(),
              home: const Controls()
          );
        },
      ),
    );
  }
}
