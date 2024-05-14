import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../service/firestore.dart';
import 'employee_presence_history.dart';

class EmployeeDetailPage extends StatelessWidget {
  final String employeeUid;

  const EmployeeDetailPage({Key? key, required this.employeeUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Detail'),
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
            final String lastName = data['last_name'];
            final String profilePic = data['photo_profile'];
            final String idEmployee = data['id_pegawai'];
            final String email = data['email'];
            final String role = data['role'];

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(profilePic),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(userName, style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      )),
                      const SizedBox(width: 5),
                      Text(lastName, style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(email),
                  const SizedBox(height: 10),
                  Text(idEmployee),
                  const SizedBox(height: 10),
                  Text('Role: $role'),
                  const SizedBox(height: 10),
                  const Text("Presence Histories"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                    child: Container(
                      width: 400,
                      height: 500,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirestoreService().getUserPresences(employeeUid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Center(child: Text('No presence data found'));
                            } else {
                              List<DocumentSnapshot> presenceList = snapshot.data!.docs;
                              return ListView.builder(
                                itemCount: presenceList.length,
                                itemBuilder: (context, index) {
                                  var presence = presenceList[index];
                                  return EmployeePresenceHistory(presence: presence);
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                ],
              ),
            );
          }
        },
      ),
    );
  }
}

