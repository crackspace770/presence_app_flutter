
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({super.key,
    required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();

  Future signUp() async{
    if(passwordIsConfirmed() ) {

      //create user
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get UID of the newly created user
      String uid = userCredential.user!.uid;
      String profilePictureUrl = 'https://ui-avatars.com/api/?background=8692F7&color=fff&size=100&rounded=true&name=${firstNameController.text.trim()}+${lastNameController.text.trim()}';

      bool isAdmin = false;

      //add user detail
      adduserDetail(
        uid,
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        emailController.text.trim(),
        int.parse(ageController.text.trim()),
        profilePictureUrl,
        isAdmin


      );
    }
  }

  Future adduserDetail(
      String uid, String firstName, String lastName, String email, int age, String photo, bool isAdmin) async {
    // Generate profile picture URL using the API and user's name
    String profilePictureUrl = 'https://ui-avatars.com/api/?background=8692F7&color=fff&size=100&rounded=true&name=$firstName+$lastName';

    // Add user details to Firestore with the generated profile picture URL
    await FirebaseFirestore.instance.collection('users').add({
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'age': age,
      'photo_profile' : profilePictureUrl, // Set profile picture URL
      'isAdmin' : isAdmin
    });
  }

  bool passwordIsConfirmed() {
    if(passwordController.text.trim() == confirmPasswordController.text.trim()){
      return true;
    } else{
      return false;
    }

  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.apple_rounded,
                  size: 70,
                ),
                const SizedBox(height:40),
                const Text("MyRegister",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Register Your Data Here",
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email"
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "First Name"
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Last Name"
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextField(
                        controller: ageController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Age"
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password"
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextField(
                        obscureText: true,
                        controller: confirmPasswordController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm Password"
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member?"),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: const Text("Sign In!",
                          style: TextStyle(
                              color: Colors.blue
                          ),
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),


        ),
      ),

    );
  }
}
