import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../service/firestore.dart';

class EmployeeDetailPage extends StatelessWidget {
  final String employeeUid;

  const EmployeeDetailPage({Key? key, required this.employeeUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Detail'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirestoreService().getUserByUid(employeeUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final String userName = data['first_name'];
            final String profilePic = data['photo_profile'];
            final String role = data['role'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (profilePic.isNotEmpty)
                    Image.network(profilePic),
                  Text('Name: $userName'),
                  Text('Role: $role'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

