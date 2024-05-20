import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/pages/admin/employee_detail_page.dart';

class EmployeeList extends StatelessWidget {
  final DocumentSnapshot employee;

  const EmployeeList({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = employee.data() as Map<String, dynamic>;
    final String firstName = data['first_name'];
    final String lastName = data['last_name'];
    final String profilePic = data['photo_profile'];
    final String idEmployee = data['id_pegawai'];
    final String employeeUid = employee.id; // Assuming the DocumentSnapshot's id is the employee's uid

    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeDetailPage(employeeUid: employeeUid),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  if (profilePic.isNotEmpty)
               CircleAvatar(
              radius: 20,
               backgroundImage: NetworkImage(profilePic),
                ),

                  const SizedBox(width: 15),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(firstName,
                          style: const TextStyle(
                          fontWeight: FontWeight.bold
                          ),
                          ),
                          const SizedBox(width: 5),
                          Text(lastName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      Text(idEmployee),
                    ],
                  )
                  // Display other employee details as needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
