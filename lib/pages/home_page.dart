import 'package:flutter/material.dart';
import 'package:presence_app/pages/presence_page.dart';
import 'package:presence_app/pages/setting_page.dart';
import 'package:presence_app/service/firestore.dart';

import '../service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  void logout(){
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PresenceApp"),
      actions: [
        GestureDetector(
            onTap: logout,
            child: const Icon(Icons.logout))
      ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ( ){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PresencePage() ) );
        },
        backgroundColor: Colors.pink,
        child: const Icon(
          Icons.fingerprint,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {

                  },
                  icon: const Icon(
                    Icons.home,
                    size: 32,
                    color: Colors.pink,
                  )),

              IconButton
                (onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage() ) );
              },
                  icon: const Icon(
                    Icons.settings,
                    size: 32,
                    color: Colors.grey,
                  ))
            ],
          ),
        ),
      ),

      body: Column(
        children: [

        ],
      ),
    );
  }
}
