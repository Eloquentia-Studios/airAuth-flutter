import 'package:airauth/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/loading_page.dart';
import 'pages/qr_reader_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'providers/otp_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => OtpProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'airAuth',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.pink[400],
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        brightness: Brightness.light,
        visualDensity: VisualDensity.standard,
        iconTheme: const IconThemeData(color: Colors.pink),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
            .copyWith(background: Colors.white),
        cardTheme: const CardTheme(color: Colors.white),
      ),
      darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 66, 66, 66),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(
            color: Colors.pink,
          ),
        ),
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          accentColor: Colors.pink[400],
          backgroundColor: Colors.grey[900],
          primarySwatch: const MaterialColor(0xFFEC407A, {}),
        ),
        cardTheme: CardTheme(color: Colors.grey[800]),
        visualDensity: VisualDensity.standard,
        iconTheme: IconThemeData(color: Colors.pink[400]),
      ),
      home: const LoadingPage(),
      routes: {
        '/signin': (BuildContext context) => const SignInPage(),
        '/signup': (BuildContext context) => const SignUpPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/qrreader': (BuildContext context) => const QRReaderPage(),
        '/settings': (BuildContext context) => const SettingsPage(),
      },
    );
  }
}
