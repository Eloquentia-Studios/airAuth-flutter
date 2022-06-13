import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/HomePage.dart';
import 'pages/QRReaderPage.dart';
import 'pages/SignInPage.dart';
import 'pages/SignUpPage.dart';
import 'providers/otp_provider.dart';
import 'pages/LoadingPage.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => OtpProvider(), child: const MyApp()));
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
      home: const LoadingPage(title: 'airAuth'),
      routes: {
        '/signin': (BuildContext context) => const SignInPage(title: 'airAuth'),
        '/signup': (BuildContext context) => const SignUpPage(title: 'airAuth'),
        '/home': (BuildContext context) => const HomePage(title: 'airAuth'),
        '/qrreader': (BuildContext context) =>
            const QRReaderPage(title: 'airAuth'),
      },
    );
  }
}
