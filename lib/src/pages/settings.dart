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
    return WillPopScope(
      onWillPop: () async { return false; },
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
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => exit(0),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      themeOf(context).buttonColor!),
                ),
                child: Text(
                  getTextFromKey("Setting.AlertDialog.Restart"),
                  style: const TextStyle(
                      color: Colors.white
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingState();
}

class _SettingState extends State<Settings> {

  String dropdownValueLocale = getTextFromKey("Settings.locale.choose");
  String dropdownValueTheme = getTextFromKey("Settings.theme.choose");
  String dropdownValueTime = getTextFromKey("Settings.time.choose");

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
                  Text(getTextFromKey("Settings.c.lang")),
                  DropdownButton<String>(
                    items:
                    <String>[
                      getTextFromKey("Settings.locale.choose"),
                      "English",
                      "Polski",
                      "Русский",
                      "Türkçe"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: dropdownValueLocale,
                    onChanged: (String? newValue) {
                      dropdownValueLocale = newValue!;
                      changeLocale(globals.locales[newValue] ?? "en");
                    },
                  ),
                ],
              ),
              const Divider(thickness: 1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTextFromKey("Settings.theme")),
                  Consumer<ThemeModel>(
                    builder: (context, notifier, child) => DropdownButton<String>(
                      items: <String>[
                        getTextFromKey("Settings.theme.choose"),
                        "Light",
                        "Dark",
                        "Amoled",
                        "Pink"
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: dropdownValueTheme,
                      onChanged: (String? newValue) async {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        dropdownValueTheme = newValue!;

                        int themeId = globals.themes[newValue] ?? 0;

                        await prefs.setInt("themeId", themeId);
                        globals.theme = themeId;
                        notifier.toggleTheme(themeId);
                      },
                    ),
                  )
                ],
              ),
              const Divider(thickness: 1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTextFromKey("Settings.notification")),
                  Switch(
                    activeColor: themeOf(context).functionalObjectsColor,
                    value: globals.notificationsToggle,
                    onChanged: (value) {
                      setState(() {
                        globals.notificationsToggle = value;
                        switchNotificationState(value);
                      });
                    },
                  )
                ],
              ),
              const Divider(thickness: 1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTextFromKey("Settings.notificationTime")),
                  DropdownButton<String>(
                    items:
                    <String>[
                      getTextFromKey("Settings.time.choose"),
                      getTextFromKey("Settings.time.15mins"),
                      getTextFromKey("Settings.time.30mins"),
                      getTextFromKey("Settings.time.1hour"),
                      getTextFromKey("Settings.time.2hours"),
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: dropdownValueTime,
                    onChanged: (String? newValue) {
                      dropdownValueTime = newValue!;
                      changeNotificationTime(globals.timesTillNotification[newValue] ?? 3600);
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