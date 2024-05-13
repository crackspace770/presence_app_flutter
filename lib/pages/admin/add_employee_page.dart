import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presence_app/widget/add_image.dart';
import 'package:presence_app/widget/my_edit_text.dart';

import '../../service/firestore.dart';

class AddEmployeePage extends StatefulWidget {

  static const routeName = "/add_employee";

  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final idController = TextEditingController();
  final ageController = TextEditingController();
  final roleController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  final FirestoreService firestoreService = FirestoreService();
  File? imageFile; // Variable to store the captured image

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> addUser() async {
    if (
    // Check if all required fields are filled
    imageFile != null &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        idController.text.isNotEmpty &&
        roleController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty
    ) {
      try {
        // Check if the email is already registered
        List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailController.text.trim());
        if (signInMethods.isNotEmpty) {
          // Email already exists, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email already registered. Please use a different email.'),
            ),
          );
          return; // Stop execution
        }

        // Create the user without automatically signing in
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Get UID of the newly created user
        String uid = userCredential.user!.uid;

        //show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent users from dismissing the dialog
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        // Upload user data to Firestore
        await firestoreService.addUser(
          imageFile: imageFile!,
          age: ageController.text,
          id: idController.text,
          role: roleController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          password: passwordController.text,
          uid: uid,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User Added.'),
          ),
        );

        // Clear form fields
        firstNameController.clear();
        lastNameController.clear();
        ageController.clear();
        idController.clear();
        roleController.clear();
        emailController.clear();
        passwordController.clear();
        setState(() {
          imageFile = null;
        });
      } catch (error) {
        // Handle error
        print('Error adding user: $error');
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error adding user. Please try again.'),
          ),
        );
      }
    } else {
      // Show error message if any form field is not filled
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture photo or complete the form'),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    idController.dispose();
    lastNameController.dispose();
    idController.dispose();
    roleController.dispose();
    ageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text("Pilih foto"),
              ),

              AddImage(
                  imageFile: imageFile,
                  onTap: _openCamera),


              const SizedBox(height: 15),

              MyEditText(
                  controller: firstNameController,
                  hintText: "First Name",
                  obscureText: false),

              const SizedBox(height: 10),

              MyEditText(
                  controller: lastNameController,
                  hintText: "Last Name",
                  obscureText: false
              ),

              const SizedBox(height: 10),

              MyEditText(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false
              ),


              const SizedBox(height: 10),

              MyEditText(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: false
              ),

              const SizedBox(height: 10),

              MyEditText(
                  controller: idController,
                  hintText: "Employee ID",
                  obscureText: false
              ),

              const SizedBox(height: 10),

              MyEditText(
                  controller: ageController,
                  hintText: "Age",
                  obscureText: false
              ),

              const SizedBox(height: 10),

              MyEditText(
                  controller: roleController,
                  hintText: "Role",
                  obscureText: false
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: addUser,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Add user",
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
