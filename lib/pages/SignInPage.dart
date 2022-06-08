import 'package:flutter/material.dart';
import '../service/http.dart';
import 'dart:convert';
import '../service/popup.dart';
import '../service/storage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final serverAddressController = TextEditingController();
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    try {
      // Get request values.
      final serverAddress = serverAddressController.text;
      final identifier = identifierController.text;
      final password = passwordController.text;

      // Send sign in request to server.
      final signInUrl = '$serverAddress/api/v1/user/login';
      final response = await Http.post(signInUrl, {}, {
        'identifier': identifier,
        'password': password,
      });

      // Parse response.
      final body = json.decode(response.body);
      if (body['token'] != null) {
        // Save token to storage.
        await Storage.set('token', body['token']);
        
        // Save server address to storage.
        await Storage.set('serverAddress', serverAddress);

        // Show success popup.
        Popup.show('Success', 'Sign in successful', context);
        
        // Navigate to home page.
        //Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Show error message.
        Popup.show('Error', body['errors'], context);
      }

      // Clear password field
      //passwordController.clear();
    } catch (e) {
      Popup.show('Error', e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('images/logo/dark-logo.png'),
                  height: 65,
                  width: 200,
                ),
                // Server address input
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Server address',
                    hintText: 'https://airauth.example.com:7331',
                  ),
                  controller: serverAddressController,
                ),

                // Username or email text field
                TextField(
                    decoration: const InputDecoration(
                      labelText: 'Username or email',
                    ),
                    controller: identifierController),

                // Password text field
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordController,
                ),
                Row(children: [Text('')]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Sign up button
                    ElevatedButton(
                      child: Text('Sign up'),
                      onPressed: () {},
                    ),

                    // Sign in button
                    ElevatedButton(child: Text('Sign in'), onPressed: signIn),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    serverAddressController.dispose();
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
