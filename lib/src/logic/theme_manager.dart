import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xff1f655d),
    appBarTheme: const AppBarTheme(color: Color(0xff1f655d)));

ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0xfff5f5f5));

ThemeData amoledTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xff1f655d),
    appBarTheme: const AppBarTheme(color: Color(0xff1f655d)));

ThemeData purpleTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0xfff5f5f5));

enum ThemeType { Light, Dark, Amoled, Purple }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;
  ThemeType _themeType = ThemeType.Light;

  toggleTheme(int id) {
    switch(id){
      case 0:
        currentTheme = lightTheme;
        _themeType = ThemeType.Light;
        return notifyListeners();
        break;
      case 1:
        currentTheme = lightTheme;
        _themeType = ThemeType.Dark;
        return notifyListeners();
        break;
      case 2:
        currentTheme = amoledTheme;
        _themeType = ThemeType.Dark;
        return notifyListeners();
        break;
      case 3:
        currentTheme = purpleTheme;
        _themeType = ThemeType.Dark;
        return notifyListeners();
        break;
      default:
        currentTheme = lightTheme;
        _themeType = ThemeType.Light;
        return notifyListeners();
        break;
    }
  }
}
