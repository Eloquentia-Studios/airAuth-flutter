import 'package:flutter/material.dart';
import 'pages/SignInPage.dart';
import 'service/storage.dart';
import 'pages/LoadingPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Build app and return it as a widget.
    return MaterialApp(
      title: 'airAuth',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.standard,
      ),
      home: const LoadingPage(title: 'airAuth - Loading'),
      routes: {
        '/signin': (BuildContext context) =>
            const SignInPage(title: 'airAuth - Sign in'),
        '/home': (BuildContext context) =>
            const SignInPage(title: 'airAuth - Home'),
      },
    );
  }
}
