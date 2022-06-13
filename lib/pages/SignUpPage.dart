import 'package:airauth/service/authentication.dart';
import 'package:flutter/material.dart';
import '../service/http.dart';
import 'dart:convert';
import '../service/popup.dart';
import '../service/storage.dart';
import '../service/validation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final serverAddressController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _updateServerAddress();
  }

  /// Update server address from storage.
  void _updateServerAddress() async {
    try {
      final serverAddress = await Authentication.getServerAddress();
      serverAddressController.text = serverAddress;
    } catch (e) {}
  }

  /// Sign up.
  Future<void> signUp() async {
    try {
      // Get request values.
      final serverAddress = serverAddressController.text;
      final username = usernameController.text;
      final email = emailController.text;
      final phoneNumber = phoneController.text;
      final password = passwordController.text;

      // Send sign up request to server.
      await Authentication.signUp(
          serverAddress, username, email, phoneNumber, password);

      // Navigate to sign in page.
      Navigator.pushReplacementNamed(context, '/signin');
    } catch (e) {
      Popup.show('Error', e.toString(), context);
    }
  }

  /// Navigate to sign in page.
  void signIn() {
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Container(
          margin: const EdgeInsets.all(30),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage('images/logo/dark-logo.png'),
                    height: 65,
                    width: 200,
                  ),
                  TextFormField(
                    controller: serverAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Server Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Server Address is required';
                      }
                      return Validation.isValidServerUrl(value);
                    },
                  ),

                  // Username text field
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return Validation.isValidUsername(value);
                      },
                      controller: usernameController),

                  // Email text field
                  TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Email', hintText: 'example@example.com'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return Validation.isValidEmail(value);
                      },
                      controller: emailController),

                  // Phone number text field
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone number (optional)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        return Validation.isValidPhoneNumber(value);
                      },
                      controller: phoneController),

                  // Password text field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      errorMaxLines: 2,
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return Validation.isValidPassword(value);
                    },
                    controller: passwordController,
                  ),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value != passwordController.text) {
                        return 'Passwords do not match!';
                      }
                      return null;
                    },
                    controller: repeatPasswordController,
                  ),

                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // Sign up button
                          ElevatedButton(
                            child: Text('Sign in'),
                            onPressed: signIn,
                          ),

                          // Sign in button
                          ElevatedButton(
                              child: Text('Sign up'),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  signUp();
                                }
                              }),
                        ],
                      ))
                ],
              ),
            ),
          ))
    ]));
  }

  @override
  void dispose() {
    serverAddressController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
