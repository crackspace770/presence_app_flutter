
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../model/user.dart';

class FirestoreService{

  String? uid;
  late CollectionReference presences;
  late CollectionReference userPresences;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference user = FirebaseFirestore.instance.collection('users');

  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

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

  Future<String> _uploadImagePhoto(File imageFile) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference storageReference = _storage.ref().child('photo/profile_pictures/');

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
  
  Stream<QuerySnapshot> getUserStream() {
    final userStream = user.orderBy('first_name', descending: true).snapshots();

    return userStream;
  }

  FirestoreService() {
    presences = FirebaseFirestore.instance.collection('presence');
    init();
  }

  Future<DocumentSnapshot> getUserByUid(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        return userSnapshot;
      } else {
        throw Exception('User with UID $uid not found.');
      }
    } catch (error) {
      print('Error retrieving user data: $error');
      throw error;
    }
  }

  Stream<QuerySnapshot> getUserPresences(String uid) {
    return _firestore.collection('users').doc(uid).collection('presence').orderBy('timestamp', descending: true).snapshots();
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

  Future<void> presenceHistory() async{
    String? uid = _usersCollection as String?;
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


  Future<void> addUser({
    required String uid,
    required File imageFile,
    required String age,
    required String id,
    required String role,
    required String firstName,
    required String lastName,
    required String email,
    required String password,

  }) async{
    try {


      // Upload the image to Firebase Storage
      String photoURL = await _uploadImagePhoto(imageFile);

      // Get the current timestamp
      DateTime now = DateTime.now();

      // Add presence data to Firestore with the photo URL
      await user.add({
        'id_pegawai': id,
        'first_name': firstName,
        'last_name':lastName,
        'role': role,
        'photo_profile': photoURL,
        'email': email,
        'password':password,
        'age':age,
        'uid':uid

      });
    } catch (error) {
      print('Error adding presence: $error');
      throw error;
    }
  }

  Future<void> addPresence({
    required File imageFile,
    required String status,
    required String id,
    required String info,
    required String name,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Upload the image to Firebase Storage
      String photoURL = await _uploadImageToStorage(imageFile, userId);

      // Get the current timestamp
      DateTime now = DateTime.now();

      // Format the timestamp
      String formattedTime = DateFormat.Hm().format(now); // HH:MM format
      String formattedDate = DateFormat('dd.MM.yy').format(now); // DD:MM:YY format

      // Add presence data to Firestore with the photo URL
      await presences.add({
        'id_pegawai': id,
        'name': name,
        'info': info,
        'photo': photoURL,
        'status': status,
        'timestamp': formattedTime,
        'date': formattedDate,
      });
    } catch (error) {
      print('Error adding presence: $error');
      throw error;
    }
  }

  Future<void> addUserPresence({
    required File imageFile,
    required String status,
    required String id,
    required String info,
    required String name,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Upload the image to Firebase Storage
      String photoURL = await _uploadImageToStorage(imageFile, userId);

      // Get the current timestamp
      DateTime now = DateTime.now();

      // Format the timestamp
      String formattedTime = DateFormat.Hm().format(now); // HH:MM format
      String formattedDate = DateFormat('dd.MM.yy').format(now); // DD:MM:YY format

      // Add presence data to Firestore with the photo URL
      await userPresences.add({
        'id': id,
        'name': name,
        'info': info,
        'photo': photoURL,
        'status': status,
        'timestamp': formattedTime,
        'date': formattedDate,
      });
    } catch (error) {
      print('Error adding presence: $error');
      throw error;
    }
  }



  Stream<QuerySnapshot> getPresences() {
    final presenceStream = userPresences.orderBy('timestamp', descending:true).snapshots();
    return presenceStream;

  }



  static Future<Users> getUserData(String userId) async {
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    return Users(name: userData['first name'], age: userData['age']);
  }



}