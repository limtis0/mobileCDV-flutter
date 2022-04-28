import 'static.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mobile_cdv/src/logic/theme_manager.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return
      RefreshConfiguration(
        footerTriggerDistance: -60,
        maxUnderScrollExtent: 200,
        enableBallisticLoad: false,
        child:
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeModel>(context).currentTheme,
          home: const Controls()
        )
    );
  }
}