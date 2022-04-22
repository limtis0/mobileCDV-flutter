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
        if(globals.isLoggedIn) { return const EventCalendar(); }
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
        SizedBox(
          width: 140,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              globals.lessonNames[type] ?? "ERROR",
              softWrap: true,
            ),
          ),
        )
      ],
    );
  }
}

Widget helpDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: themeOf(context).popUpBackgroundColor,
    title: Text(
      getTextFromKey("Static.HelpDialog"),
      textAlign: TextAlign.center,
    ),
    content: SizedBox(
      height: 450,
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: Fill all lesson types
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "W",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "L",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "C",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "TODO_PROJEKT",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "WR",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "TODO_E_LEARNING",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "LK",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "TODO_PRAKTYKI",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "TODO_SEMINARIUM",
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "TODO_KONWERSATORIUM",
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "TODO_SPOTKANIE",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "EGSAM",
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "TODO_REZERWACJA",
                                context: context,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "TODO_DYZUR",
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1.5,),
            Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                  width: 250,
                  child: Text(
                    getTextFromKey("Static.HelpText1"),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                  width: 250,
                  child: Text(
                    getTextFromKey("Static.HelpText2"),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                  width: 250,
                  child: Text(
                    getTextFromKey("Static.HelpText3"),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                )
            ),
          ],
        )
      )
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
  //String _title = getTextFromKey("Main.Schedule");

  PreferredSizeWidget _customAppBar(int index) {
    switch(index) {
      case 0:
        return AppBar(
          title: Text(getTextFromKey("Main.Account")),
        );
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
        return AppBar(
          title: Text(getTextFromKey("Main.Settings")),
        );
    }
  }

  void _onItemTapped(int? index) {
    if (globals.isLoggedIn && _selectedIndex == 1 && index == 1){
      return EventCalendarState().calendarToToday();
    }
    setState(() {
      _selectedIndex = index!;
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
            _onItemTapped(index);
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
