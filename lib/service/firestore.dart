
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user.dart';

class FirestoreService{

  String? uid;
  late CollectionReference presences;
  late CollectionReference userPresences;

  FirestoreService() {
    uid = FirebaseAuth.instance.currentUser?.uid;
    presences = FirebaseFirestore.instance.collection('presence');
    userPresences = FirebaseFirestore.instance.collection('user').doc(uid).collection('presence');
  }


  Future<void> addPresence(
      String presence, String photo, bool status, String id, String info, String name ) {

    return presences.add( {
      'id': id,
      'name' : name,
      'info': info,
      'presence' : presence,
      'photo': photo,
      'status': status,
      'timestamp' : Timestamp.now(),
      'date' : DateTime.now()
    });

  }

  Future<void> addUserPresence(
      String presence, String photo, bool status, String id, String info, String name ) {

    return userPresences.add( {
      'id': id,
      'name' : name,
      'info': info,
      'presence' : presence,
      'photo': photo,
      'status': status,
      'timestamp' : Timestamp.now(),
      'date' : DateTime.now()
    });

  }

  Stream<QuerySnapshot> getPresences() {
    final presenceStream = presences.orderBy('timestamp', descending:true).snapshots();
    return presenceStream;

  }

  static Future<Users> getUserData(String userId) async {
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    return Users(name: userData['first name'], age: userData['age']);
  }



}