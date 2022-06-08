import 'package:flutter/material.dart';

import 'pages/SignInPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'airAuth',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.standard,
      ),
      home: const SignInPage(title: 'airAuth'),
    );
  }
}

