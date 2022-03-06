import 'package:flutter/material.dart';

import '../widgets/restart_widget.dart';
import 'package:mobile_cdv/src/lib/lozalization/localization_manager.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              Text(
                getTextFromKey("Settings.locale")
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          initLocalization("en");
                          RestartWidget.restartApp(context);
                        },
                        child: const Text(
                          "English"
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          initLocalization("pl");
                          RestartWidget.restartApp(context);
                        },
                        child: const Text(
                            "Polski"
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          initLocalization("ru");
                          RestartWidget.restartApp(context);
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
    );
  }
}
