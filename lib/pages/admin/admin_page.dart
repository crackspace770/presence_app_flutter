import 'package:flutter/material.dart';

import '../../service/auth_service.dart';

class AdminPage extends StatefulWidget {

  static const routeName ="/admin_page";

  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

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
    );
  }
}
