import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  primaryColor: Colors.white,
  brightness: Brightness.light,
);

ThemeData dark = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
);

ThemeData? getThemeById(int id){
  switch(id){
    case 0:
      return light;
      break;
    case 1:
      return dark;
      break;
  }
  return null;
}