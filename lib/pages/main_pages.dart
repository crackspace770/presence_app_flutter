
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin/admin_page.dart';
import 'auth/auth_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  static const routeName="/main_page";

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user?.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Check if any documents are found
                  if (snapshot.data!.docs.isNotEmpty) {
                    var document = snapshot.data!.docs.first;
                    print('Document data: ${document.data()}'); // Print document data
                    bool isAdmin = document['isAdmin'] ?? false;
                    print('isAdmin: $isAdmin'); // Print isAdmin value
                    if (isAdmin) {
                      // Redirect to AdminPage
                      return AdminPage();
                    } else {
                      // Redirect to HomePage
                      return HomePage();
                    }
                  } else {
                    // Handle case when no documents are found
                    return Center(child: Text('No user data found'));
                  }
                }
              },
            );
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}