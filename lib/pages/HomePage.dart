import 'package:airauth/components/OtpItem.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var devOtpItems = <Widget>[];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 10; i++) {
      devOtpItems.add(OtpItem());
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.all(5),
          child: Center(child: ListView(children: devOtpItems)),
        ));
  }
}
