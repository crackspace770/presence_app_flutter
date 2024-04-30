import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(), // Replace 'YOUR_USER_ID' with the actual user ID
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            print(snapshot.connectionState); // Check the connection state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Text('No data found');
            }

            // Extract user data from snapshot
            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
            print(userData); // Check the user data retrieved from Firestore
            String firstName = userData['first name'];
            String idPegawai = userData['id_pegawai'];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                Text(firstName), // Display user's first name
                SizedBox(height: 15),
                Text(idPegawai), // Display user's ID
              ],
            );
          },
        ),
      ),
    );
  }
}
