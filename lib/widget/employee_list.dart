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
    final String idEmployee = data['id_pegawai'];
    final String employeeUid = employee.id; // Assuming the DocumentSnapshot's id is the employee's uid

    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 8, left: 8, bottom: 8),
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

              const SizedBox(height: 15),

              if (profilePic.isNotEmpty)
                Image.network(profilePic,
                height: 80,
                  width: 80,
                ),

              Text(userName),
              Text(idEmployee)
              // Display other employee details as needed
            ],
          ),
        ),
      ),
    );
  }
}
