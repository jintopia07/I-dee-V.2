import 'package:flutter/material.dart';
import 'package:idee_flutter/screen/about_page.dart';
import 'package:idee_flutter/screen/emergency_page.dart';
import 'package:idee_flutter/screen/follow_page.dart';
import 'package:idee_flutter/screen/home_page.dart';
import 'package:idee_flutter/screen/loginuser_page.dart';

class Launcher extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _LauncherState();
  }
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 0;
  List<Widget> _pageWidget = <Widget>[
    Home(),
    EmergencyPage(),
    FollowPage(),
    //LoginAdmin(),
    About(),
  ];
  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('หน้าแรก'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mic),
      title: Text('ร้องเรียน'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.dock),
      title: Text('ติดตาม'),
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.lock),
    //   title: Text('เข้าสู่ระบบ'),
    // ),
    BottomNavigationBarItem(
      icon: Icon(Icons.info),
      title: Text('เกี่ยวกับเรา'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
