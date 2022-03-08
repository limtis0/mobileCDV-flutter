import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/logic/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'static.dart';

class LoginApp extends StatelessWidget {
  LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeModel>(context).currentTheme,
        home: LoginCanvas()
    );
  }
}

