import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/model/presence.dart';

class PresenceHistory extends StatelessWidget {

  final presence;

  const PresenceHistory({super.key, required this.presence});

  @override
  Widget build(BuildContext context) {

    DocumentSnapshot document = presence as DocumentSnapshot<Object?>;
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
              Icon(Icons.circle,color: _getStatusColor(presenceStatus)),
              Text(presenceStatus),
              Text(presenceTime.toString()),
            ],

          ),
        ),
      ),
    );;
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
