import 'dart:ui';

import 'package:airauth/models/Otp.dart';
import 'package:flutter/material.dart';

class OtpItem extends StatefulWidget {
  late final Otp otp;

  //const OtpItem({Key? key}) : super(key: key);

  OtpItem(this.otp, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OtpItemState();
}

class _OtpItemState extends State<OtpItem> {
  var _isShowing = false;
  var _otpCode = '';

  void tapToReveal() {
    setState(() {
      _otpCode = widget.otp.getCode();
      _isShowing = !_isShowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Row(children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(0),
                child: ListTile(
                  title: Text(widget.otp.issuer),
                  subtitle: Text(widget.otp.label),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: _isShowing
                        ? Text(_otpCode,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500))
                        : IconButton(
                            onPressed: tapToReveal,
                            icon: const Icon(
                              Icons.touch_app_sharp,
                              color: Colors.pink,
                              size: 30,
                            )))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
