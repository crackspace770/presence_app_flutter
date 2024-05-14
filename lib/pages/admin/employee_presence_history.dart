import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeePresenceHistory extends StatelessWidget {

  final DocumentSnapshot presence;

  const EmployeePresenceHistory({super.key, required this.presence});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = presence.data() as Map<String, dynamic>;
    String presenceStatus = data['status'].toString();
    String presenceTime = data['timestamp'].toString();
    String presenceDate = data['date'].toString();

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
              Icon(Icons.circle, color: _getStatusColor(presenceStatus)),
              Text(presenceStatus),
              Text(presenceTime),
              Text(presenceDate),
            ],
          ),
        ),
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'Check In':
      return Colors.green;
    case 'Check Out':
      return Colors.blue;
    case 'Izin':
      return Colors.red;
    default:
      return Colors.black;
  }
}
