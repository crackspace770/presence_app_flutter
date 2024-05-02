import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/pages/presence_page.dart';
import 'package:presence_app/pages/setting_page.dart';
import 'package:presence_app/service/firestore.dart';

import '../service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  void logout() {
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
            child: const Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const PresencePage()));
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
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.home,
                    size: 32,
                    color: Colors.pink,
                  )),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings, size: 32, color: Colors.grey)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: FutureBuilder<void>(
          future: _firestoreService.init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for initialization
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle error if initialization fails
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // If initialization is successful, show the UI
              return StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getPresences(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List presenceList = snapshot.data!.docs;

                    // Display as list
                    return ListView.builder(
                      itemCount: presenceList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = presenceList[index];
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        String presenceStatus = data['status'].toString();
                         DateTime presenceTime = (data['date'] as Timestamp ).toDate();



                        return Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(presenceStatus),
                                  Text(presenceTime.toString()),
                                ],

                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0, bottom: 25.0, top: 25.0),
                          child: Text("No Data"),
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
