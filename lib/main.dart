import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/qr_reader_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'providers/otp_provider.dart';
import 'pages/loading_page.dart';

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
      home: const LoadingPage(),
      routes: {
        '/signin': (BuildContext context) => const SignInPage(),
        '/signup': (BuildContext context) => const SignUpPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/qrreader': (BuildContext context) => const QRReaderPage(),
      },
    );
  }
}
