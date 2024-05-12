import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatelessWidget {

  final employee;

  const EmployeeList({super.key, this.employee});

  @override
  Widget build(BuildContext context) {

    DocumentSnapshot document = employee as DocumentSnapshot<Object?>;

    //get user from each docs
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String userName = data['first_name'];
    String profilePic = data['photo_profile'];
    String role = data['role'];

    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(userName)
          ],
        ),
      ),
    );
  }
}
