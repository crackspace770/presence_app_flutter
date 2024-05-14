import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/pages/admin/add_employee_page.dart';

import '../../service/firestore.dart';
import '../../widget/employee_list.dart';

class EmployeePage extends StatefulWidget {

  static const routeName ="/employee_page";

  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddEmployeePage.routeName);
        },
        backgroundColor: Colors.pink,
        child: const Icon(
            Icons.add,
            size: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder<QuerySnapshot> (
          stream: firestoreService.getUserStream(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List userList = snapshot.data!.docs;
              //display as list
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items per row
                    crossAxisSpacing: 2, // Spacing between items horizontally
                    mainAxisSpacing: 4, // Spacing between items vertically
                  ),
                  itemCount: userList.length,
                  itemBuilder: (context, index) {


                    var employee = userList[index];
                    return EmployeeList(employee: employee);

                  }
              );
            } else{
              return Center(
                child: Text("No Data"),
              );
            }
          },

        ),
      ),
    );
  }
}
