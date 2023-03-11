import 'package:airauth/service/authentication.dart';
import 'package:airauth/service/local_authentication.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  /// Check sign in status and navigate to the next page.
  void checkSignInStatus(BuildContext context) async {
    if (await Authentication.isLoggedIn()) {
      Authentication.refreshToken();
      await verifyLogin(context);
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  /// Verify the user is authenticated.
  Future<void> verifyLogin(BuildContext context) async {
    while (true) {
      final authenticated = !await LocalAuthentication.isLocalAuthEnabled() ||
          await LocalAuthentication.authenticate(
              "Dude, you have to be authenticated or we will kill you");

      if (authenticated) {
        Navigator.pushReplacementNamed(context, '/home');
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check sign in status.
    checkSignInStatus(context);

    return Scaffold(
        body: Container(
      margin: const EdgeInsets.all(30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(
              image: AssetImage('images/logo/dark-logo.png'),
              height: 65,
              width: 200,
            ),
          ],
        ),
      ),
    ));
  }
}
