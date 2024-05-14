import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/pages/admin/employee_detail_page.dart';

class EmployeeList extends StatelessWidget {
  final DocumentSnapshot employee;

  const EmployeeList({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = employee.data() as Map<String, dynamic>;
    final String userName = data['first_name'];
    final String profilePic = data['photo_profile'];
    final String role = data['role'];
    final String employeeUid = employee.id; // Assuming the DocumentSnapshot's id is the employee's uid

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeDetailPage(employeeUid: employeeUid),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(userName),
              // Display other employee details as needed
            ],
          ),
        ),
      ),
    );
  }
}
