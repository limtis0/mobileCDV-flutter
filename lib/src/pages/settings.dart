import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';

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

/*
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
                        });
                        initLocalization("ru");
                      },
                      child: const Text(
                          "Русский"
                      ),
                    ),
                  ],
                ),
 */