import 'dart:io' show exit;

import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic/theme_manager.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;
import 'package:mobile_cdv/src/logic/notifications.dart';

class LocaleDialog extends StatelessWidget {
  const LocaleDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(
        getTextFromKey("Settings.AlertDialog")
      ),
      content: Text(
        getTextFromKey("Settings.AlertDialog.q")
      ),
      actions: [
        ElevatedButton(
          onPressed: () => exit(0),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                themeOf(context).buttonColor!)
          ),
          child: Text(
            getTextFromKey("Setting.AlertDialog.Restart"),
            style: const TextStyle(
                color: Colors.white
            ),
          ),
        )
      ],
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingState();
}

class _SettingState extends State<Settings> {

  final String _currentLocale = getTextFromKey("Settings.locale");
  String dropdownValue = getTextFromKey("Settings.locale.choose");
  String dropdownValueTheme = getTextFromKey("Settings.theme.choose");

  void changeLocale(String loc){
    initLocalization(loc);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          return const LocaleDialog();
        }
    );
  }

  Future<void> switchNotificationState(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!value){
      await NotificationService().cancelAllNotifications();
    }else {
      await NotificationService().setNotificationQueue(globals.notificationsTime, 32);
    }
    await prefs.setBool("notificationsToggle", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTextFromKey("Settings.c.lang")
                  ),
                  DropdownButton<String>(
                    items: <String>[getTextFromKey("Settings.locale.choose"), "English", "Polski", "Русский", "Türkçe"].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      dropdownValue = newValue!;
                      switch(newValue){
                        case "English":
                          changeLocale("en");
                          break;
                        case "Polski":
                          changeLocale("pl");
                          break;
                        case "Русский":
                          changeLocale("ru");
                          break;
                        case "Türkçe":
                          changeLocale("tr");
                          break;
                        default:
                          initLocalization("en");
                          break;
                      }
                    },
                  ),
                ],
              ),
              const Divider(
                thickness: 1.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTextFromKey("Settings.theme")
                  ),
                  Consumer<ThemeModel>(
                    builder: (context, notifier, child) => DropdownButton<String>(
                      items: <String>[getTextFromKey("Settings.theme.choose"), "Light", "Dark", "Amoled", "Pink"].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: dropdownValueTheme,
                      onChanged: (String? newValue) async {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        dropdownValueTheme = newValue!;
                        switch(newValue){
                          case "Light":
                            globals.theme = 0;
                            await prefs.setInt('themeId', 0);
                            notifier.toggleTheme(0);
                            break;
                          case "Dark":
                            globals.theme = 1;
                            await prefs.setInt('themeId', 1);
                            notifier.toggleTheme(1);
                            break;
                          case "Amoled":
                            globals.theme = 2;
                            await prefs.setInt('themeId', 2);
                            notifier.toggleTheme(2);
                            break;
                          case "Pink":
                            globals.theme = 3;
                            await prefs.setInt('themeId', 3);
                            notifier.toggleTheme(3);
                            break;
                          default:
                            globals.theme = 0;
                            await prefs.setInt('themeId', 0);
                            notifier.toggleTheme(0);
                            break;
                        }
                      },
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 1.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTextFromKey("Settings.notification")
                  ),
                  Switch(
                    activeColor: themeOf(context).functionalObjectsColor,
                    value: globals.notificationsToggle,
                    onChanged: (value){
                      setState(() {
                        globals.notificationsToggle = value;
                        switchNotificationState(value);
                      });
                    },
                  )
                ],
              ),
              const Divider(
                thickness: 1.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}