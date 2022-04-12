import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;

// TODO Rewrite all themes

// Не редачить, только если очень хочеться
ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.grey[700]!,
  primaryColorLight: Colors.black,
  backgroundColor: Colors.grey[200]!,
  bottomAppBarColor: Colors.blue,
  disabledColor: Colors.blue,
  cardColor: Colors.white,
  focusColor: Colors.lightBlueAccent,
  hintColor: Colors.black,
  toggleableActiveColor: Colors.blue,
  errorColor: Colors.white
);

// Не редачить, только если очень хочеться
ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  primaryColorLight: Colors.white,
  backgroundColor: const Color(0xFF333333),
  appBarTheme: const AppBarTheme(color: Color(0xff00ADB5)),
  bottomAppBarColor: Colors.white,
  toggleableActiveColor: const Color(0xff00ADB5),
  colorScheme: const ColorScheme.dark().copyWith
    (secondary: const Color(0xff00ADB5)),
  errorColor: Colors.white
);
// ДАЛЬШЕ ИДУТ КАСТОМНЫЕ ТЕМЫ
/*
* Цвет не обезательно должен быть в хексе (смотри документацию) можно и просто  Colors.red
* Названия переменых ничего не значат, смотри мои коменты (Костыль да, но если будем обновы делать поменяю уже так уж и быть)
* Чтобы создать новую тему нужно связаться со мной там на фронте нужно добавлять риколы, если захочеш могу показать
* Чтобы увидеть изменения темы нужно полностью перезагрузить приложение (Хот релоад не работает!!!)
* */
// Тема амолед ..................  ↓ наслдевать тему от light или dark
ThemeData amoledTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.white,                                 // цвет текста в ивентах
  primaryColorLight: Colors.white,                            // цвет дней недели
  appBarTheme: const AppBarTheme(color: Colors.black),        // цвет апп бара (панель сверху)
  canvasColor: Colors.black,                                  // цвет ботом бара (панель внизу)
  bottomAppBarColor: Colors.white,                            // цвет выбранной категории в ботом баре
  backgroundColor: const Color(0xFF262626),                   // цвет бэк граунда в ивентах
  scaffoldBackgroundColor: Colors.black,                      // цвет бэк граунда в окнах
  disabledColor: const Color(0xFF262626),                     // цвет кнопок и рамки вокруг аватарки (если че скажи я вынесу отдельным полем)
  cardColor: const Color(0xFF262626),                         // цвет бэкграунда в поп апе
  focusColor: const Color(0xFF262626),                        // цвет круга в календаре (сегодняшний день)
  hintColor: Colors.white,                                    // цвет текста в форме логина
  toggleableActiveColor: Colors.white,                        // цвет тоглла в настройках нотификаций
  colorScheme: const ColorScheme.dark().copyWith              // цвет оверфлова при пролистывании
    (secondary: Colors.white),
  errorColor: Colors.white,                                    // цвет текста на кнопке в профиле (вова ты чево наделал...)
);

// Pink theme
ThemeData pinkTheme = ThemeData.light().copyWith(
  primaryColor: const Color(0xFFE18AAA),
  primaryColorLight: const Color(0xFFE18AAA),
  appBarTheme: const AppBarTheme(color: Color(0xFFE18AAA)),
  canvasColor: const Color(0xFFE18AAA),
  backgroundColor: const Color(0xFFFBD3ED),
  scaffoldBackgroundColor: const Color(0xFFFDEBF7),
  disabledColor: const Color(0xFFE18AAA),
  bottomAppBarColor: const Color(0xFFFDEBF7),
  cardColor: const Color(0xFFFDEBF7),
  hintColor: const Color(0xFFE4A0B7),
  focusColor: const Color(0xFFFBD3ED),
  toggleableActiveColor: const Color(0xFFE18AAA),
  colorScheme: const ColorScheme.light().copyWith
    (secondary: const Color(0xFFE18AAA)),
  errorColor: Colors.white
);


ThemeData setTheme() {
  switch(globals.theme) {
    case 0:
      return lightTheme;
    case 1:
      return darkTheme;
    case 2:
      return amoledTheme;
    case 3:
      return pinkTheme;
    default:
      return lightTheme;
  }
}

// Не редачить
enum ThemeType { Light, Dark, Amoled, Purple }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = setTheme();
  ThemeType? _themeType;

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
        currentTheme = pinkTheme;
        _themeType = ThemeType.Dark;
        return notifyListeners();
      default:
        currentTheme = lightTheme;
        _themeType = ThemeType.Light;
        return notifyListeners();
    }
  }
}
