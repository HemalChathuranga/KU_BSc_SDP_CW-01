import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdp_project/signup.dart';
import 'package:sdp_project/home.dart';

final formKey = GlobalKey<FormState>();
final TextEditingController name = TextEditingController();
final TextEditingController password = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _visible = false;

  // Log-in function
  Future userLogin(BuildContext context) async {
    String url = "http://192.168.0.101/SDP_api/login.php";

    setState(() {
      _visible = true;
    });
    var data = {
      'username': name.text,
      'password': password.text,
    };
    //print();
    try {
      var response = await http.post(Uri.parse(url), body: data);
      // print(response);
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.body);
        if (msg['status'] == "1") {
          setState(() {
            _visible = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
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
                            "Invalid Username or Password",
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
        setState(() {
          _visible = false;
          showMessage("Error during connecting to Server.");
        });
      }
    } on SocketException catch (_) {
      // Handle connection refusal here
      setState(() {
        _visible = false;
        showMessage(
            "Connection refused. Please check your internet connection.");
      });
    } catch (error) {
      setState(() {
        _visible = false;
        showMessage("Error: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputField(context),
              _forgotPassword(),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return const Column(
      children: [
        Text(
          "Welcome to ECCS",
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          "Enter your credentials to login",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a email';
              }
              return null;
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: password,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              // Validate returns true if the form is valid, or false otherwise.
              if (formKey.currentState!.validate()) {
                await userLogin(context);
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgotPassword() {
    return TextButton(onPressed: () {}, child: const Text("Forgot password?"));
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Signup()),
              );
            },
            child: const Text("Sign Up")),
      ],
    );
  }

  void showMessage(String message) {
    // Implement your message display logic, e.g., using a dialog
    print(message);
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
