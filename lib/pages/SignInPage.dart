import 'package:airauth/service/authentication.dart';
import 'package:flutter/material.dart';
import '../service/popup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Initialize form controllers.
  final serverAddressController = TextEditingController();
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateServerAddress();
  }

  /// Fetch server address from storage and update the server address controller.
  void _updateServerAddress() async {
    try {
      final serverAddress = await Authentication.getServerAddress();
      serverAddressController.text = serverAddress;
    } catch (_) {}
  }

  /// Sign in with the given [identifier] and [password].
  void signIn() async {
    // Get request values.
    final serverAddress = serverAddressController.text;
    final identifier = identifierController.text;
    final password = passwordController.text;

    try {
      // Send sign in request to server.
      await Authentication.signIn(serverAddress, identifier, password);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Show error message.
      Popup.show('Error', e.toString(), context);
    }

    // Clear password field
    passwordController.clear();
  }

  /// Navigate to sign up page.
  void signUp() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Sign up button
                  ElevatedButton(
                    onPressed: signUp,
                    child: const Text('Sign up'),
                  ),

                  // Sign in button
                  ElevatedButton(
                    onPressed: signIn,
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    serverAddressController.dispose();
    identifierController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}
