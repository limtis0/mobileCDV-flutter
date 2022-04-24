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

  // Language-change dialogue
  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async { return false; }, // Prevents dialogue from popping
      child: AlertDialog(
          backgroundColor: themeOf(context).popUpBackgroundColor,
          title: Text(
            getTextFromKey("Settings.AlertDialog"),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTextFromKey("Settings.AlertDialog.q"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => exit(0),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      themeOf(context).buttonColor!)
                ),
                child: Text(
                  getTextFromKey("Setting.AlertDialog.Restart"),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          )
      ),
    );
  }
}

// Settings page
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  // On-settings-changed functions
  void changeLocale(String loc){
    initLocalization(loc);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) { return const LocaleDialog(); }
    );
  }

  Future<void> switchNotificationState(bool toggle) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (toggle) {
      await NotificationService().setNotificationQueue();
    }else {
      await NotificationService().cancelAllNotifications();
    }
    await prefs.setBool("notificationsToggle", toggle);
    globals.notificationsToggle = toggle;
  }

  Future<void> changeNotificationTime(int seconds) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("notificationsTime", seconds);
    globals.notificationsTime = seconds;

    if (globals.notificationsToggle) {
      NotificationService().setNotificationQueue();
    }
  }

  // Page
  String dropdownValueLocale = globals.locale;
  int _dropdownValueTheme = globals.theme;
  int _dropdownValueTime = globals.notificationsTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // LANGUAGE DROPDOWN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTextFromKey("Settings.c.lang")),
                  DropdownButton<String>(
                    items:
                    globals.locales.map((description, value) {
                      return MapEntry(
                        description,
                        DropdownMenuItem<String>(
                          value: value,
                          child: Text(description),
                        ));
                    })
                        .values.toList(),
                    value: dropdownValueLocale,
                    onChanged: (String? newValue) {
                      dropdownValueLocale = newValue!;
                      changeLocale(newValue);
                    },
                  ),
                ],
              ),
              const Divider(thickness: 1.5),
              // THEME DROPDOWN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTextFromKey("Settings.theme")),
                  Consumer<ThemeModel>(
                    builder: (context, notifier, child) => DropdownButton<int>(
                      items: globals.themes.map((description, value) {
                        return MapEntry(
                          description,
                          DropdownMenuItem<int>(
                            value: value,
                            child: Text(description),
                          ));
                        })
                          .values.toList(),
                      value: _dropdownValueTheme,
                      onChanged: (int? newValue) async {
                        _dropdownValueTheme = newValue!;
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setInt("themeId", newValue);
                        globals.theme = newValue;
                        notifier.toggleTheme(newValue);
                      },
                    ),
                  )
                ],
              ),
              const Divider(thickness: 1.5),
              // NOTIFICATIONS SWITCH
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTextFromKey("Settings.notification")),
                  Switch(
                    activeColor: themeOf(context).functionalObjectsColor,
                    value: globals.notificationsToggle,
                    onChanged: (value) {
                      switchNotificationState(value);
                      setState(() {
                        globals.notificationsToggle = value;
                      });
                    },
                  )
                ],
              ),
              const Divider(thickness: 1.5),
              // NOTIFICATIONS TIME DROPDOWN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTextFromKey("Settings.notificationTime")),
                  DropdownButton<int>(
                    items:
                    globals.timesTillNotification.map((description, value) {
                      return MapEntry(
                        description,
                        DropdownMenuItem<int>(
                          value: value,
                          child: Text(description),
                        ));
                    })
                        .values.toList(),
                    value: _dropdownValueTime,
                    onChanged: (int? newValue) {
                      _dropdownValueTime = newValue!;
                      changeNotificationTime(newValue);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}