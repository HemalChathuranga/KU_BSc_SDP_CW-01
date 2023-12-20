import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdp_project/home.dart';
//import 'package:email_validator/email_validator.dart';

//this is use for test purpose.

void main() {
  runApp(const MaterialApp(
    home: Signup(),
  ));
}

final _formKey = GlobalKey<FormState>();
final TextEditingController fullNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController numberController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController cPasswordController = TextEditingController();

//Signup main class

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Registration"),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[900],
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: _SignupForm(),
      ),
    );
  }
}

//Signup form

class _SignupForm extends StatelessWidget {
  const _SignupForm();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 70,
            child: CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: 65,
              child: Icon(
                Icons.person,
                color: Color(0xffCCCCCC),
                size: 70,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTextFormField(
            controller: fullNameController,
            hintText: 'Full Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: emailController,
            hintText: 'Email',
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Email is Required';
              } else if (RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]")
                  .hasMatch(v)) {
                return null;
              }
              return 'Invalid Email';
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: numberController,
            hintText: 'Phone Number',
            // Add validation for birth day if needed
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: passwordController,
            hintText: 'Password',
            validator: (val) {
              if (val?.isEmpty ?? true) {
                return 'Password cannot be empty';
              }
              // Add additional password validation if needed
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: cPasswordController,
            hintText: 'Confirm Password',
            validator: (val) {
              if (val?.isEmpty ?? true) {
                return 'Confirm Password cannot be empty';
              }
              if (val != passwordController.text) {
                return 'Passwords do not match';
              }
              return null; // Return null when validation passes
            },
            obscureText: true,
          ),


          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity, // Make the button take the full width
            child: ElevatedButton(
              onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    await userReg(context);
                    print("Hi button pressed");
                  }
                },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(25.0), // Set the border radius
                ), backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
      ),
    );
  }

  //Register button function

  // Future<void> _saveContact(BuildContext context) async {
  //   if (_formKey.currentState!.validate()) {
  //       await userReg();
  //     }
  //    // print('Contact saved!');
  //   }
  }

Future userReg(BuildContext context) async {
  String url = "http://192.168.0.101/SDP_api/signup.php";

  // setState(() {
  //   _visible = true;
  // });

  var data = {
    'username': fullNameController.text,
    'email': emailController.text,
    'password' : passwordController.text,
    'contact_no': numberController.text,
  };
  print(data);
  try {
    var response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      var msg = jsonDecode(response.body);
      if (msg['status'] == "4") {
        // setState(() {
        //   _visible = false;
        // });

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const Home(),
        //   ),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.all(8),
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Invalid",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "User already exist",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 3,
          ),
        );
      }
    } else {
      // setState(() {
      //   _visible = false;
      //   showMessage("Error during connecting to Server.");
      // });
    }
  } on SocketException catch (_) {
    // Handle connection refusal here
    // setState(() {
    //   _visible = false;
    //   showMessage(
    //       "Connection refused. Please check your internet connection.");
    // });
  } catch (error) {
    // setState(() {
    //   _visible = false;
    //   showMessage("Error: $error");
    // });
  }
}

_successMessage(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ), // BoxDecoration
      ))); // Container // SnackBar
}


