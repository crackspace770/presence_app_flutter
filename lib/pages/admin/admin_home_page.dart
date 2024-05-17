import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/widget/presence_list.dart';

import '../../service/firestore.dart';
import '../../widget/presence_history.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  final User? user = FirebaseAuth.instance.currentUser;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user?.uid).get(),
        // Query the collection based on the user's UID
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          Map<String, dynamic>? userData = snapshot.data!.docs.first.data() as Map<String, dynamic>?;

          String firstName = userData?['first_name'] ?? 'Unknown';
          String idPegawai = userData?['id_pegawai'] ?? 'Unknown';
          String lastName = userData?['last_name'] ?? 'Unknown';
          String profilePic = userData?['photo_profile']?? 'Unknown';

          return SingleChildScrollView(
            child: Column(
            
              children: [
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
            
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 5),
                          Text("Hello, $firstName ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),),
                          Text(idPegawai),
                        ],
                      ),
            
            
                      if (profilePic.isNotEmpty)
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(profilePic),
                        ),
            
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  color: Colors.white,
                  width: 500,
                  height: 300,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: EdgeInsets.only(left: 15.0,top: 15),
                        child: Text("Recent Activity",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),),
                      ),


            
                      PresenceList(),
            
                    ],
                  ),
            
                ),
            
              ],
            ),
          );
        },
      ),
    );
  }
}
