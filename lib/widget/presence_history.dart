import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class PresenceHistory extends StatelessWidget {
  final presence;

  const PresenceHistory({super.key, required this.presence});

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot document = presence as DocumentSnapshot<Object?>;
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String presenceStatus = data['status'].toString();
    String presenceTime = data['timestamp'].toString();
    String presenceDate = data['date'].toString();
    String presenceState = data['state'].toString();

    // Parse the presence time
    DateTime parsedPresenceTime = DateFormat.Hm().parse(presenceTime);

    // Define the threshold times
    DateTime checkInThreshold = DateFormat.Hm().parse("08:00");
    DateTime checkOutThreshold = DateFormat.Hm().parse("17:00");


    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(presenceStatus),
                      Icon(Icons.circle, color: _getStatusColor(presenceState)),
                    ],
                  ),
                  Text(presenceDate.toString()),
                ],
              ),
              Column(
                children: [
                  Text(presenceTime.toString()),
                  Text(presenceState), // Display the presence state
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}




Color _getStatusColor(String status) {
  // Return color based on status
  switch (status) {
    case 'On Time':
      return Colors.green; // Green color for Check In
    case 'Early':
      return Colors.blue; // Blue color for Check Out
    case 'Late':
      return Colors.red; // Red color for Izin
    default:
      return Colors.black; // Default color
  }
}
