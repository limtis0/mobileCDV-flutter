import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;


class ThemeExtensionFields {
  final Color? popUpBackgroundColor;
  final Color? eventBackgroundColor;
  final Color? eventTextColor;
  final Color? fieldTextColor;
  final Color? calendarWeekdaysColor;
  final Color? calendarFocusedDayColor;
  final Color? bottomBarColor;
  final Color? bottomBarSelectedColor;
  final Color? buttonColor;
  final Color? functionalObjectsColor;

  const ThemeExtensionFields({
    this.popUpBackgroundColor,
    this.eventBackgroundColor,
    this.eventTextColor,
    this.fieldTextColor,
    this.calendarWeekdaysColor,
    this.calendarFocusedDayColor,
    this.bottomBarColor,
    this.bottomBarSelectedColor,
    this.buttonColor,
    this.functionalObjectsColor,
  });

  // Null-safety
  factory ThemeExtensionFields.empty() {
    return const ThemeExtensionFields(
      popUpBackgroundColor: Colors.white,
      eventBackgroundColor: Color(0xFFEEEEEE),
      eventTextColor: Color(0xFF616161),
      fieldTextColor: Colors.black,
      calendarWeekdaysColor: Colors.black,
      calendarFocusedDayColor: Colors.lightBlueAccent,
      bottomBarColor: Colors.white,
      bottomBarSelectedColor: Colors.blue,
      buttonColor: Colors.blue,
      functionalObjectsColor: Colors.blue,
    );
  }
}

extension ThemeDataExtensions on ThemeData {
  static final Map<int, ThemeExtensionFields> _own = {};

  void addOwn(ThemeExtensionFields own) {
    _own[globals.theme] = own;
  }

  static ThemeExtensionFields? empty;

  // Null-safety
  ThemeExtensionFields own() {
    var o = _own[globals.theme];
    if (o == null) {
      empty ??= ThemeExtensionFields.empty();
      o = empty;
    }
    return o!;
  }
}
// Helper method. Call themeOf(context) to get the color in widgets
ThemeExtensionFields themeOf(BuildContext context) => Theme.of(context).own();


// THEMES
ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.grey[50]!,
)
  ..addOwn(const ThemeExtensionFields(
    popUpBackgroundColor: Colors.white,
    eventBackgroundColor: Color(0xFFEEEEEE),
    eventTextColor: Color(0xFF616161),
    fieldTextColor: Colors.black,
    calendarWeekdaysColor: Colors.black,
    calendarFocusedDayColor: Colors.lightBlueAccent,
    bottomBarColor: Colors.white,
    bottomBarSelectedColor: Colors.blue,
    buttonColor: Colors.blue,
    functionalObjectsColor: Colors.blue,
));

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.grey[850]!, // App-Background color
  appBarTheme: const AppBarTheme(color: Color(0xff00ADB5)), // Top-bar color
  colorScheme: const ColorScheme.dark().copyWith // Scroll overflow color
    (secondary: const Color(0xFF00ADB5)),
)
  ..addOwn(const ThemeExtensionFields(
    popUpBackgroundColor: Color(0xFF424242),
    eventBackgroundColor: Color(0xFF424242),
    eventTextColor: Colors.white,
    fieldTextColor: Color(0xFFACACAC),
    calendarWeekdaysColor: Colors.white,
    calendarFocusedDayColor: Color(0xFF494949),
    bottomBarColor: Color(0xFF303030),
    bottomBarSelectedColor: Colors.white,
    buttonColor: Color(0xFF787878),
    functionalObjectsColor: Color(0xff00ADB5),
));

ThemeData amoledTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(color: Colors.black),
  colorScheme: const ColorScheme.dark().copyWith
    (secondary: Colors.white),
)
  ..addOwn(const ThemeExtensionFields(
  popUpBackgroundColor: Color(0xFF262626),
  eventBackgroundColor: Color(0xFF262626),
  eventTextColor: Colors.white,
  fieldTextColor: Colors.white,
  calendarWeekdaysColor: Colors.white,
  calendarFocusedDayColor: Color(0xFF262626),
  bottomBarColor: Colors.black,
  bottomBarSelectedColor: Colors.white,
  buttonColor: Color(0xFF303030),
  functionalObjectsColor: Colors.white,
));

ThemeData pinkTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xFFFDEBF7),
  appBarTheme: const AppBarTheme(color: Color(0xFFE18AAA)),
  colorScheme: const ColorScheme.light().copyWith
    (secondary: const Color(0xFFE18AAA)),
)
  ..addOwn(const ThemeExtensionFields(
    popUpBackgroundColor: Color(0xFFFDEBF7),
    eventBackgroundColor: Color(0xFFFBD3ED),
    eventTextColor: Color(0xFFE18AAA),
    fieldTextColor: Color(0xFFE4A0B7),
    calendarWeekdaysColor: Color(0xFFE18AAA),
    calendarFocusedDayColor: Color(0xFFFBD3ED),
    bottomBarColor: Color(0xFFE18AAA),
    bottomBarSelectedColor: Color(0xFFFDEBF7),
    buttonColor: Color(0xFFE18AAA),
    functionalObjectsColor: Color(0xFFE18AAA),
));


// Logic
final Map<int, ThemeData> themes = {
  0: lightTheme,
  1: darkTheme,
  2: amoledTheme,
  3: pinkTheme,
};

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = themes[globals.theme] ?? lightTheme;

  toggleTheme(int id) {
    currentTheme = themes[id] ?? lightTheme;
    return notifyListeners();
  }
}
