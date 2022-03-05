import 'package:flutter/material.dart';
import 'logic/request.dart';

// Pages
import 'widgets/timetable.dart';
import 'pages/profile.dart';
import 'pages/settings.dart';


class Canvas extends StatelessWidget {
  int page_id;

  Canvas({Key? key, required this.page_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (page_id){
      case 0:
        return Profile();
      case 1:
        return EventCalendar();
      case 2:
        return Settings();
      default:
        return Text("404");
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          _title = "Profile";
          break;
        case 1:
          _title = "Timetable";
          break;
        case 2:
          _title = "Settings";
          break;
        default:
          _title = "Mobile CDV";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _title
        ),
      ),
      body: SafeArea(
        child: Canvas(page_id: _selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.person
              ),
              label: "Profile"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.schedule
              ),
              label: "Timetable"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.settings
              ),
              label: "Settings"
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
