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
              ],
            ),
          ),
        )
      );
  }
}
