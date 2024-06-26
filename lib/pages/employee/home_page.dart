import 'package:flutter/material.dart';
import 'package:presence_app/pages/employee/presence_history_page.dart';
import 'package:presence_app/pages/employee/presence_page.dart';
import 'package:presence_app/pages/employee/setting_page.dart';

import '../../service/auth_service.dart';

class HomePage extends StatefulWidget {

  static const routeName ="/home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  int _bottomNavIndex = 0;

  final List<Widget> _listWidget = [
    const PresenceHistoryPage(),
    const SettingPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon( Icons.home),
      label: "Home",
    ),

    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Profile",
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PresenceApp"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: logout,
            child: const Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, PresencePage.routeName);
        },
        backgroundColor: Colors.pink,
        child: const Icon(
          Icons.fingerprint,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(

        selectedItemColor: Colors.purple,
        currentIndex: _bottomNavIndex,
        backgroundColor: Colors.white54,

        items: _bottomNavBarItems,
        onTap: (selected) {
          setState(() {
            _bottomNavIndex = selected;
          });
        },
      ),
    );
  }
}
