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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Row(children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(0),
                child: ListTile(
                  title: Text(widget.otp.id),
                  subtitle: Text(widget.otp.url),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: _isShowing
                        ? Text('420 420',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500))
                        : Icon(
                            Icons.touch_app_sharp,
                            color: Colors.pink,
                            size: 30,
                          )),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
