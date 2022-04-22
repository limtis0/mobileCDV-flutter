import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;
import 'package:mobile_cdv/src/logic/theme_manager.dart';

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

class ReqLoginPage extends StatelessWidget{
  const ReqLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getTextFromKey("noSchedule.page"),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 35,
            ),
          )
        ],
      ),
    );
  }
}

class Canvas extends StatelessWidget {
  final int pageId;
  final bool isLogged = false;

  const Canvas({Key? key, required this.pageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (pageId){
      case 0:
        return const ProfileLogin();
      case 1:
        if (globals.isLoggedIn) { return const EventCalendar(); }
        return const ReqLoginPage();
      case 2:
        return const Settings();
      default:
        return const Text("404");
    }
  }
}

class HelpItem extends StatelessWidget {
  final String type;
  final BuildContext? context;
  const HelpItem({Key? key, required this.type, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 5,
          backgroundColor: globals.lessonColors[type] ?? Colors.grey,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(globals.lessonNames[type] ?? "ERROR"),
          ),
        )
      ],
    );
  }
}

Widget helpDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: themeOf(context).popUpBackgroundColor,
    title:
    Text(getTextFromKey("Static.HelpDialog"), textAlign: TextAlign.center),
    content:
    Wrap(
      // TODO: Fill all lesson types
      children: <Widget>[
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wrap(
                direction: Axis.vertical,
                spacing: 5,
                children: const [
                  HelpItem(type: "W"),
                  HelpItem(type: "L"),
                  HelpItem(type: "C"),
                  HelpItem(type: "TODO_PROJEKT"),
                ],
              ),
              const SizedBox(width: 10),
              Wrap(
                direction: Axis.vertical,
                spacing: 5,
                children: const [
                  HelpItem(type: "WR"),
                  HelpItem(type: "TODO_E_LEARNING"),
                  HelpItem(type: "LK"),
                  HelpItem(type: "TODO_PRAKTYKI"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                direction: Axis.vertical,
                spacing: 5,
                children: const [
                  HelpItem(type: "TODO_SEMINARIUM"),
                  HelpItem(type: "TODO_KONWERSATORIUM"),
                  HelpItem(type: "TODO_SPOTKANIE"),
                  HelpItem(type: "EGSAM"),
                  HelpItem(type: "TODO_REZERWACJA"),
                  HelpItem(type: "TODO_DYZUR"),
                ],
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(10), child: Divider(thickness: 1.5)),
          Column(
            children: <Widget>[
              Text(
                getTextFromKey("Static.HelpText1"),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Text(
                getTextFromKey("Static.HelpText2"),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Text(
                getTextFromKey("Static.HelpText3"),
                textAlign: TextAlign.center,
                softWrap: true,
              )
            ]
          ),
        ],
      )]
    )
  );
}

class Controls extends StatefulWidget {
  const Controls({Key? key}) : super(key: key);

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  int _selectedIndex = 1;

  PreferredSizeWidget _customAppBar(int index) {
    switch(index) {
      case 0:
        return AppBar(title: Text(getTextFromKey("Main.Account")));
      case 1:
        return AppBar(
          title: Text(getTextFromKey("Main.Schedule")),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return helpDialog(context);
                    },
                  );
                },
                icon: const Icon(Icons.help_outline),
              ),
            )
          ],
        );
      default:
        return AppBar(title: Text(getTextFromKey("Main.Settings")));
    }
  }

  final PageController controller = PageController(initialPage: 1);
  void goTo(int index){
    if (globals.isLoggedIn && _selectedIndex == 1 && index == 1) {
      return EventCalendarState().calendarToToday();
    }
    controller.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.ease);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _customAppBar(_selectedIndex),
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: const [
            Canvas(pageId: 0),
            Canvas(pageId: 1),
            Canvas(pageId: 2),
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: themeOf(context).bottomBarColor,
        items: getBottomTabs(_bottomTabs),
        currentIndex: _selectedIndex,
        selectedItemColor: themeOf(context).bottomBarSelectedColor,
        onTap: goTo,
      ),
    );
  }
}
