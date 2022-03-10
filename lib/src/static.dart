import 'dart:io';

import 'package:flutter/material.dart';

import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/pages/login_page.dart';
import 'package:mobile_cdv/src/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_cdv/src/logic/globals.dart' as globals;

// Pages
import 'pages/profile.dart';
import 'pages/settings.dart';

import 'widgets/event_calendar.dart';


class BottomTabs {
  String title;
  IconData icon;

  BottomTabs(this.title, this.icon);
}

List<BottomTabs> _bottomTabs = [
  BottomTabs(getTextFromKey("Main.Account"), Icons.person),
  BottomTabs(getTextFromKey("Main.Schedule"), Icons.schedule),
  BottomTabs(getTextFromKey("Main.Settings"), Icons.settings)
];
List<BottomNavigationBarItem> getBottomTabs(List<BottomTabs> items){

  return items.map((item) => BottomNavigationBarItem(icon: Icon(item.icon), label: item.title)).toList();
}

class Canvas extends StatelessWidget {
  final int page_id;
  bool isLogged = false;

  Canvas({Key? key, required this.page_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (page_id){
      case 0:
        if(globals.isLoggined) {
          return Profile();
        }else {
          return ProfileLogin();
        }
      case 1:
        return EventCalendar();
      case 2:
        return const Settings();
      default:
        return const Text("404");
    }
  }
}

class Controls extends StatefulWidget {
  const Controls({Key? key}) : super(key: key);

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  int _selectedIndex = 1;
  String _title = 'Timetable';
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int? index) {
    setState(() {
      _selectedIndex = index!;
      switch (_selectedIndex) {
        case 0:
          _title = getTextFromKey("Main.Account");
          break;
        case 1:
          _title = getTextFromKey("Main.Schedule");
          break;
        case 2:
          _title = getTextFromKey("Main.Settings");
          break;
        default:
          _title = "Mobile CDV";
          break;
      }
    });
  }

  final PageController controller = PageController(initialPage: 1);

  void goTo(int index){
    controller.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.ease);
    _onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
            _title
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [
            Canvas(page_id: 0),
            Canvas(page_id: 1),
            Canvas(page_id: 2),
          ],
          onPageChanged: (index) {
            _onItemTapped(index);
          }
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: getBottomTabs(_bottomTabs),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: goTo,
      ),
    );
  }
}
