import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/service/firestore.dart';
import 'package:presence_app/widget/employee_list.dart';

import '../../service/auth_service.dart';
import 'admin_setting_page.dart';
import 'employee_page.dart';

class AdminPage extends StatefulWidget {

  static const routeName ="/admin_page";
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  final FirestoreService firestoreService = FirestoreService();

  int _bottomNavIndex = 0;

  final List<Widget> _listWidget = [
    const EmployeePage(),
    const AdminSettingPage(),
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

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Page"),
        actions: [
          GestureDetector(
            onTap: logout,
            child: Icon(Icons.logout),
          )
        ],
      ),
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
