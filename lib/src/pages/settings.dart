import 'dart:ffi';
import 'dart:io';

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
        getTextFromKey("Settings.AlertDialog")
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

  String _currentLocale = getTextFromKey("Settings.locale");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                _currentLocale
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _currentLocale = "Language";
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return const LocaleDialog();
                              }
                            );
                          });
                          initLocalization("en");
                        },
                        child: const Text(
                            "English"
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _currentLocale = "Język";
                            showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return const LocaleDialog();
                                }
                            );
                          });
                          initLocalization("pl");
                        },
                        child: const Text(
                            "Polski"
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _currentLocale = "Язык";
                            showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return const LocaleDialog();
                                }
                            );
                          });
                          initLocalization("ru");
                        },
                        child: const Text(
                            "Русский"
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}