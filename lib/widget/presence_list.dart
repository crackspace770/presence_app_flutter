import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/widget/presence_history.dart';

import '../service/firestore.dart';

class PresenceList extends StatefulWidget {
  const PresenceList({super.key});

  @override
  State<PresenceList> createState() => _PresenceListState();
}

class _PresenceListState extends State<PresenceList> {

  final User? user = FirebaseAuth.instance.currentUser;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: FutureBuilder<void>(
        future: _firestoreService.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for initialization
            return const Center(child: CircularProgressIndicator());
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
                    shrinkWrap: true,
                    itemCount: presenceList.length,
                    itemBuilder: (context, index) {
                      var presence = presenceList[index];
                      return PresenceHistory(presence: presence);
                    },
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 25.0, bottom: 25.0, top: 25.0),
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
    );
  }
}
