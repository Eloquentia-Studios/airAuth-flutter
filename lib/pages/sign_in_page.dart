import 'package:airauth/service/authentication.dart';
import 'package:airauth/service/error_data.dart';
import 'package:airauth/service/validation.dart';
import 'package:flutter/material.dart';

import '../service/popup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Initialize form controllers.
  final _serverAddressController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  // Logos.
  static const _lightLogo = AssetImage('images/logo/light-logo.png');
  static const _darkLogo = AssetImage('images/logo/dark-logo.png');

  // Create a global key that uniquely identifies the Form widget.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _updateServerAddress();
  }

  /// Fetch server address from storage and update the server address controller.
  void _updateServerAddress() async {
    try {
      final serverAddress = await Authentication.getServerAddress();
      _serverAddressController.text = serverAddress;
    } catch (_) {}
  }

  /// Sign in with the given [identifier] and [password].
  void signIn() async {
    // Get request values.
    final serverAddress = _serverAddressController.text;
    final identifier = _identifierController.text;
    final password = _passwordController.text;

    try {
      // Send sign in request to server.
      await Authentication.signIn(serverAddress, identifier, password);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      final error = ErrorData.handleException(e);
      Popup.show(error.title, error.message, context);
    }

    // Clear password field
    _passwordController.clear();
  }

  /// Navigate to sign up page.
  void signUp() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    // Detect color theme.
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
        body: ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: isDark ? _lightLogo : _darkLogo,
                    height: 65,
                    width: 200,
                  ),
                  // Server address input
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Server address',
                      hintText: 'https://airauth.example.com:7331',
                    ),
                    controller: _serverAddressController,
                    validator: (value) => Validation.isValidServerUrl(value),
                  ),

                  AutofillGroup(
                      child: Column(
                    children: [
                      TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Username or email',
                          ),
                          autofillHints: const [AutofillHints.username],
                          controller: _identifierController,
                          validator: (value) =>
                              Validation.isNotEmptyString(value, 'Username')),

                      // Password text field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        autofillHints: const [AutofillHints.password],
                        controller: _passwordController,
                        validator: (value) =>
                            Validation.isNotEmptyString(value, 'Password'),
                      ),
                    ],
                  )),
                  // Username or email text field

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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signIn();
                            }
                          },
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _serverAddressController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
