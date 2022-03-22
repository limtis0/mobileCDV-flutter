import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
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
  bool isLogged = false;

  Canvas({Key? key, required this.pageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (pageId){
      case 0:
        return const ProfileLogin();
      case 1:
        if(globals.isLoggedIn) {
          return const EventCalendar();
        }else {
          return const ReqLoginPage();
        }
      case 2:
        return const Settings();
      default:
        return const Text("404");
    }
  }
}

class HelpItem extends StatelessWidget {
  String type;
  String textKey;
  BuildContext? context;
  HelpItem({Key? key, required this.type, required this.textKey, this.context}) : super(key: key);

  Color? setColor(String type){
    switch(type){
      case "W":
        return Colors.green;
      case "WR":
        return Colors.blue[200];
      case "L":
        return Colors.blue;
      case "LK":
        return Colors.purpleAccent;
      case "C":
        return Colors.orange;
      case "EGSAM":
        return Colors.purple;
      case "EMPTY":
        return Theme.of(context!).cardColor;
    //TODO Сделать цвета
    /*case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;*/
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 5,
          backgroundColor: setColor(type),
        ),
        SizedBox(
          width: 140,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              getTextFromKey(textKey),
              softWrap: true,
            ),
          ),
        )
      ],
    );
  }
}

Widget HelpDialog(BuildContext context) {
  return AlertDialog(
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
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "W",
                          textKey: "Static.Wyklad",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "L",
                          textKey: "Static.Labaratoria",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "C",
                          textKey: "Static.Cwiczenia",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "TODO",
                          textKey: "Static.Projekt",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "WR",
                          textKey: "Static.Warsztaty",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "ELEARNING TODO",
                          textKey: "Static.Elearning",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "LK",
                          textKey: "Static.Lektorat",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: HelpItem(
                          type: "TODO",
                          textKey: "Static.Praktyki",
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
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "TODO",
                                textKey: "Static.Seminarium",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "TODO",
                                textKey: "Staic.Konwesatorium",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "EGSAM",
                                textKey: "Static.Spotkanie",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "EMPTY",
                                textKey: "Static.Zaliczenie",
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
                                type: "EMPTY",
                                textKey: "Static.Rezewacja",
                                context: context,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: HelpItem(
                                type: "EMPTY",
                                textKey: "Static.Dyzur",
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
                      return HelpDialog(context);
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

  //TODO refactor
  bool isSchedule = false;
  void _onItemTapped(int? index) {
    setState(() {
      _selectedIndex = index!;
      switch (_selectedIndex) {
        case 1:
          if (isSchedule) {
            refreshCalendar();
          } else {
            isSchedule = true;
          }
          break;
      }
    });
  }

  final PageController controller = PageController(initialPage: 1);

  //TODO refactor
  void refreshCalendar(){
    setState(() {
      isSchedule = false;
      controller.animateToPage(2, duration: const Duration(microseconds: 1), curve: Curves.ease).whenComplete(() =>
          controller.animateToPage(1, duration: const Duration(microseconds: 1), curve: Curves.ease));
    });
  }

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
          children: [
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
        backgroundColor: Theme.of(context).canvasColor,
        items: getBottomTabs(_bottomTabs),
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).bottomAppBarColor,
        onTap: goTo,
      ),
    );
  }
}
