
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/user.dart';

class FirestoreService{

  String? uid;
  late CollectionReference presences;
  late CollectionReference userPresences;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> _uploadImageToStorage(File imageFile, String userId) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference storageReference = _storage.ref().child('photo/selfie/$userId');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL of the uploaded file
      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      throw e;
    }
  }

  FirestoreService() {
    presences = FirebaseFirestore.instance.collection('presence');
    init();
  }

  Future<void> init() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      QuerySnapshot userDocs = await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).get();
      if (userDocs.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userDocs.docs.first;
        userPresences = userDoc.reference.collection('presence');
      } else {
        // Handle case when user document is not found
      }
    } else {
      // Handle the case where the user is not authenticated
    }
  }


  Future<void> addPresence({
    required File imageFile,
    required bool status,
    required String id,
    required String info,
    required String name,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Upload the image to Firebase Storage
      String photoURL = await _uploadImageToStorage(imageFile, userId);

      // Add presence data to Firestore with the photo URL
      await presences.add({
        'id': id,
        'name': name,
        'info': info,
        'photo': photoURL,
        'status': status,
        'timestamp': Timestamp.now(),
        'date': DateTime.now(),
      });
    } catch (error) {
      print('Error adding presence: $error');
      throw error;
    }
  }

  Future<void> addUserPresence({
    required File imageFile,
    required bool status,
    required String id,
    required String info,
    required String name,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Upload the image to Firebase Storage
      String photoURL = await _uploadImageToStorage(imageFile, userId);

      // Add presence data to Firestore with the photo URL
      await userPresences.add({
        'id': id,
        'name': name,
        'info': info,
        'photo': photoURL,
        'status': status,
        'timestamp': Timestamp.now(),
        'date': DateTime.now(),
      });
    } catch (error) {
      print('Error adding presence: $error');
      throw error;
    }
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