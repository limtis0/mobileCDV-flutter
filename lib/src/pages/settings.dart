import 'dart:io' show exit;

import 'package:flutter/material.dart';

import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';

class LocaleDialog extends StatelessWidget {
  const LocaleDialog({Key? key}) : super(key: key);

  //TODO do design
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
          child: Text(
            getTextFromKey("Setting.AlertDialog.Restart")
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    getTextFromKey("Settings.c.lang")
                  ),
                  DropdownButton(
                      items: <String>["English", "Polski", "Русский"].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    onChanged: (String? newValue) {
                        switch(newValue){
                          case "English":
                            initLocalization("en");
                            showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return const LocaleDialog();
                                }
                            );
                            break;
                          case "Polski":
                            initLocalization("pl");
                            showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return const LocaleDialog();
                                }
                            );
                            break;
                          case "Русский":
                            initLocalization("ru");
                            showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return const LocaleDialog();
                                }
                            );
                            break;
                          default:
                            initLocalization("en");
                            break;
                        }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}