
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/auth_service.dart';
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
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<QuerySnapshot?>(
              future: _authService.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  QuerySnapshot? userDocs = snapshot.data;
                  if (userDocs != null && userDocs.docs.isNotEmpty) {
                    var document = userDocs.docs.first;
                    print('Document data: ${document.data()}'); // Print document data
                    String? role = document['role'];
                    if (role == 'admin') {
                      // Redirect to Teacher page
                      print('Redirecting to Admin...');
                      return const AdminPage();
                    } else if (role == 'employee') {
                      // Redirect to Student page
                      print('Redirecting to Employee...');
                      return const HomePage();
                    } else {
                      print('Unknown role: $role');
                      // Handle unknown role here
                      return const Center(child: Text('Unknown role'));
                    }
                  } else {
                    // Handle case when no documents are found
                    print('No user document found.');
                    return const Center(child: Text('No user data found'));
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