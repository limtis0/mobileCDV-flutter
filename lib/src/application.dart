import 'package:flutter/material.dart';

import 'widgets/restart_widget.dart';
import 'static.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RestartWidget(
        child: Controls(),
      )
    );
  }
}

