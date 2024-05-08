import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

//sign out
  Future<void> signOut() async{
    return await _auth.signOut();
  }

  // Get the role of the user
  Future<QuerySnapshot?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot userDocs = await _firestore.collection('users').where('uid', isEqualTo: user.uid).get();
      return userDocs;
    } else {
      return null; // User is not authenticated
    }
  }


}