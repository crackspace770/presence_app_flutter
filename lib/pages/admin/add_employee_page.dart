import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presence_app/widget/MyEditText.dart';

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

  Future addUser() async{
    if (
    //to make sure every form is filled
    imageFile != null &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        idController.text.isNotEmpty &&
        roleController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty
    ) {

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

      //upload to firestore
      try {
        await firestoreService.addUser(
            imageFile: imageFile!,
            age: ageController.text,
            id: idController.text,
            role: roleController.text,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            email: emailController.text,
            password: passwordController.text
        );

        //if success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User Added.'),
          ),
        );

        // Navigate back to the previous page
        Navigator.pop(context);

        // Optionally, show a success message or navigate to another screen
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
      // Show error message if any form is not filled
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture photo or complete the form'),
        ),
      );
    }
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
                        : const Icon(
                      Icons.camera_alt,
                      size: 150,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),

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
