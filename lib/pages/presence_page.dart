import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presence_app/service/firestore.dart';

class PresencePage extends StatefulWidget {

  static const routeName = "/presence_page";

  const PresencePage({Key? key}) : super(key: key);

  @override
  _PresencePageState createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  String? selectedStatus;
  String hintText = 'Status';

  final user = FirebaseAuth.instance.currentUser;
  final FirestoreService firestoreService = FirestoreService();

  //controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  File? imageFile; // Variable to store the captured image

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Function to fetch user data from Firestore

  void fetchUserData() async {
    try {
      // Fetch user document from Firestore based on user's UID
      QuerySnapshot userDocs = await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user?.uid).get();

      if (userDocs.docs.isNotEmpty) {
        // Extract first name and ID from user document
        Map<String, dynamic>? userData = userDocs.docs.first.data() as Map<String, dynamic>?;

        // Set first name and ID to controllers
        nameController.text = userData?['first_name'] ?? '';
        idController.text = userData?['id_pegawai'] ?? '';
      } else {
        print('User document not found');
        // Handle case when user document is not found
      }
    } catch (error) {
      print('Error fetching user data: $error');
      // Handle error fetching user data
    }
  }

  // Function to open camera and capture image
  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Presence"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text("Ambil Foto selfie"),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: _openCamera, // Open camera when icon is tapped
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      shape: BoxShape.rectangle,
                    ),
                    child: imageFile != null // Show captured image if available
                        ? Image.file(
                      imageFile!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                        : Icon(
                      Icons.camera_alt,
                      size: 150,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: TextField(
                      controller: nameController,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: "Nama Pegawai", border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: TextField(
                      controller: idController,
                      enabled: false,
                      decoration: const InputDecoration(
                          hintText: "ID Pegawai", border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: DropdownButton<String>(
                      hint: Text(hintText),
                      value: selectedStatus,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStatus = newValue;
                          hintText = newValue ?? 'Status';
                        });
                      },
                      items: <String>['Check In', 'Check Out', 'Izin']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Presence Status: ${selectedStatus ?? 'Select a status'}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: TextField(
                      controller: keteranganController,
                      decoration: InputDecoration(
                          hintText: "Keterangan", border: InputBorder.none),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () async {
                    if (imageFile != null && selectedStatus != null) {

                      showDialog(
                        context: context,
                        barrierDismissible: false, // Prevent users from dismissing the dialog
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      String status = selectedStatus ?? '';

                      try {
                        await firestoreService.addPresence(

                          imageFile: imageFile!, // Pass the imageFile
                          status: status,
                          id: idController.text,
                          info: keteranganController.text,
                          name: nameController.text,
                        );

                        await firestoreService.addUserPresence(
                          imageFile: imageFile!, // Pass the imageFile
                          status: status,
                          id: idController.text,
                          info: keteranganController.text,
                          name: nameController.text,
                        );


                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Presence Added.'),
                          ),
                        );

                        // Navigate back to the previous page
                        Navigator.pop(context);

                        // Optionally, show a success message or navigate to another screen
                      } catch (error) {
                        // Handle error
                        print('Error adding presence: $error');
                        // Show error message to user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error adding presence. Please try again.'),
                          ),
                        );
                      }
                    } else {
                      // Show error message if image or status is not selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please capture photo and select status'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Absen!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}




