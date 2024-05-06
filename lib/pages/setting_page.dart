import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  static const routeName ="/setting_page";

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user?.uid).get(),
        // Query the collection based on the user's UID
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }

          Map<String, dynamic>? userData = snapshot.data!.docs.first.data() as Map<String, dynamic>?;

          String firstName = userData?['first_name'] ?? 'Unknown';
          String idPegawai = userData?['id_pegawai'] ?? 'Unknown';
          String lastName = userData?['last_name'] ?? 'Unknown';
          String profilePictureUrl = userData?['photo_profile']?? 'Unknown';

          return Center(
            child: Column(

              children: [
                SizedBox(height: 15),
                profilePictureUrl.isNotEmpty
                    ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profilePictureUrl),
                )
                    : Container(),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(firstName),
                    SizedBox(width: 5),
                    Text(lastName),
                  ],
                ),
                SizedBox(height: 15),
                Text(idPegawai), // Display user's ID
                SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
