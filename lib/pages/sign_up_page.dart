import 'package:airauth/service/authentication.dart';
import 'package:flutter/material.dart';
import '../service/popup.dart';
import '../service/validation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Initialize form controllers.
  final _serverAddressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  // Logos.
  static const _lightLogo = AssetImage('images/logo/light-logo.png');
  static const _darkLogo = AssetImage('images/logo/dark-logo.png');

  // Create a global key that uniquely identifies the Form widget.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Fetch server address from storage and update the server address controller.
    _updateServerAddress();
  }

  /// Update server address from storage.
  void _updateServerAddress() async {
    try {
      final serverAddress = await Authentication.getServerAddress();
      _serverAddressController.text = serverAddress;
    } catch (_) {}
  }

  /// Sign up.
  Future<void> signUp() async {
    try {
      // Get request values.
      final serverAddress = _serverAddressController.text;
      final username = _usernameController.text;
      final email = _emailController.text;
      final phoneNumber = _phoneController.text;
      final password = _passwordController.text;

      // Send sign up request to server.
      await Authentication.signUp(
          serverAddress, username, email, phoneNumber, password);

      // Navigate to sign in page.
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/signin');
    } catch (e) {
      Popup.show('Error', e.toString(), context);
    }
  }

  /// Navigate to sign in page.
  void signIn() {
    Navigator.pushReplacementNamed(context, '/signin');
  }

  /// Check if both passwords match.
  String? passwordsMatch(String? value) {
    if (Validation.isEqual(_passwordController.text, value)) {
      return null;
    }
    return 'Passwords do not match.';
  }

  @override
  Widget build(BuildContext context) {
    // Detect color theme.
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                  Image(
                    image: isDark ? _lightLogo : _darkLogo,
                    height: 65,
                    width: 200,
                  ),

                  // Server address.
                  TextFormField(
                    controller: _serverAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Server Address',
                    ),
                    validator: (value) => Validation.isValidServerUrl(value),
                  ),

                  // Username text field
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      autofillHints: const [AutofillHints.username],
                      validator: (value) => Validation.isValidUsername(value),
                      controller: _usernameController),

                  // Email text field
                  TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Email', hintText: 'example@example.com'),
                      autofillHints: const [AutofillHints.email],
                      validator: (value) => Validation.isValidEmail(value),
                      controller: _emailController),

                  // Phone number text field
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone number (optional)',
                      ),
                      autofillHints: const [AutofillHints.telephoneNumber],
                      validator: (value) =>
                          Validation.isValidPhoneNumber(value),
                      controller: _phoneController),

                  // Password text field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      errorMaxLines: 2,
                    ),
                    autofillHints: const [AutofillHints.password],
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) => Validation.isValidPassword(value),
                    controller: _passwordController,
                  ),

                  // Confirm password text field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    autofillHints: const [AutofillHints.password],
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: passwordsMatch,
                    controller: _repeatPasswordController,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // Sign up button
                          ElevatedButton(
                            onPressed: signIn,
                            child: const Text('Sign in'),
                          ),

                          // Sign in button
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signUp();
                              }
                            },
                            child: const Text('Sign up'),
                          ),
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
    // Clean up the controller when the widget is disposed.
    _serverAddressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
