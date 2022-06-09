import 'package:flutter/material.dart';
import '../service/http.dart';
import 'dart:convert';
import '../service/popup.dart';
import '../service/storage.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void checkSignInStatus(BuildContext context) async {
    try {
      // Get token from storage.
      await Storage.get('token');

      // Go to home page.
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Go to sign in page.
      Navigator.pushReplacementNamed(context, '/signin');
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
