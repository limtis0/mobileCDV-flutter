import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/logic/theme_manager.dart';
import 'static.dart';

class themeSettings {
  int id;
  ThemeData data;

  themeSettings(this.id, this.data);
}

ThemeData getTheme(themeSettings theme){
  return theme => ThemeData()
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  final ThemeData? mainTheme = getThemeById(0);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      home: Controls()
    );
  }
}

