import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_cdv/src/logic/globals.dart' as globals;

ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0xfff5f5f5)
);

ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xff1f655d), //
    appBarTheme: const AppBarTheme(color: Color(0xff1f655d)) // цвет верхней панели
);

ThemeData amoledTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xFF000000),
    appBarTheme: const AppBarTheme(color: Color(0xFF000000)),
);

ThemeData purpleTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xaacc66cc),
    appBarTheme: const AppBarTheme(color: Color(0xaacc66cc)),
);


// Не редачить
enum ThemeType { Light, Dark, Amoled, Purple }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;
  ThemeType _themeType = ThemeType.Light;

  ThemeData setTheme() {
    switch(globals.theme){
      case 0:
        currentTheme = lightTheme;
        _themeType = ThemeType.Light;
        return lightTheme;
      case 1:
        currentTheme = darkTheme;
        _themeType = ThemeType.Dark;
        return darkTheme;
      case 2:
        currentTheme = amoledTheme;
        _themeType = ThemeType.Dark;
        return amoledTheme;
      case 3:
        currentTheme = purpleTheme;
        _themeType = ThemeType.Dark;
        return purpleTheme;
      default:
        currentTheme = lightTheme;
        _themeType = ThemeType.Light;
        return lightTheme;
    }
  }

  toggleTheme(int id) {
    switch(id){
      case 0:
        currentTheme = lightTheme;
        _themeType = ThemeType.Light;
        return notifyListeners();
      case 1:
        currentTheme = darkTheme;
        _themeType = ThemeType.Dark;
        return notifyListeners();
      case 2:
        currentTheme = amoledTheme;
        _themeType = ThemeType.Dark;
        return notifyListeners();
      case 3:
        currentTheme = purpleTheme;
        _themeType = ThemeType.Dark;
        return notifyListeners();
      default:
        currentTheme = lightTheme;
        _themeType = ThemeType.Light;
        return notifyListeners();
    }
  }
}
