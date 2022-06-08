import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  int _counter = 0;
  ImageProvider _logoProvider = AssetImage('images/logo/dark-logo.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: _logoProvider, height: 65, width: 200,),
                // Server address input
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Server address',
                    hintText: 'https://airauth.example.com:7331',
                  ),
                ),

                // Username or email text field
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Username or email',
                  ),
                ),

                // Password text field
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                Row(children: [Text('')]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Sign up button
                    ElevatedButton(
                      child: Text('Sign up'),
                      onPressed: () {},
                    ),

                    // Sign in button
                    ElevatedButton(
                      child: Text('Sign in'),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
