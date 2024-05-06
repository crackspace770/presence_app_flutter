import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/pages/presence_page.dart';
import 'package:presence_app/widget/presence_history.dart';

import '../service/auth_service.dart';
import '../service/firestore.dart';

class PresenceHistoryPage extends StatefulWidget {
  static const routeName ="/presence_history_page";

  const PresenceHistoryPage({super.key});

  @override
  State<PresenceHistoryPage> createState() => _PresenceHistoryPageState();
}

class _PresenceHistoryPageState extends State<PresenceHistoryPage> {

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
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
                        var presence = presenceList[index];
                        return PresenceHistory(presence: presence);
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

Color _getStatusColor(String status) {
  // Return color based on status
  switch (status) {
    case 'Check In':
      return Colors.green; // Green color for Check In
    case 'Check Out':
      return Colors.blue; // Blue color for Check Out
    case 'Izin':
      return Colors.red; // Red color for Izin
    default:
      return Colors.black; // Default color
  }
}
