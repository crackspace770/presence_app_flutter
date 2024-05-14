import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  static const routeName ="/setting_page";



  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    Future<void> changeProfilePic() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            String uid = user.uid;

            // Upload the selected image to Firebase Storage
            TaskSnapshot storageSnapshot = await FirebaseStorage.instance
                .ref('photo/profile/$uid.jpg')
                .putFile(File(image.path));

            // Get the download URL of the uploaded image
            String photoURL = await storageSnapshot.ref.getDownloadURL();

            // Query Firestore to get the document with the matching UID
            QuerySnapshot userDocs = await FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: uid)
                .get();

            if (userDocs.docs.isNotEmpty) {
              // Get the document ID
              String docId = userDocs.docs.first.id;

              // Update the document with the download URL of the new profile picture
              await FirebaseFirestore.instance.collection('users').doc(docId).update({
                'photo_profile': photoURL,
              });

              print('Profile picture updated successfully.');
            } else {
              print('User document not found.');
            }
          } else {
            print('User not authenticated.');
          }
        } catch (error) {
          print('Error changing profile picture: $error');
        }
      }
    }

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
                const SizedBox(height: 15),
                profilePictureUrl.isNotEmpty
                    ? Stack(
                  children: [
                    GestureDetector(
                      onTap: changeProfilePic,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profilePictureUrl),
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 10,
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ],
                )
                    : Container(),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(firstName),
                    const SizedBox(width: 5),
                    Text(lastName),
                  ],
                ),
                const SizedBox(height: 15),
                Text(idPegawai), // Display user's ID
                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
