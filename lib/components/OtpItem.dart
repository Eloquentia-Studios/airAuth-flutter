import 'dart:async';
import 'dart:ui';

import 'package:airauth/models/Otp.dart';
import 'package:flutter/material.dart';

import '../service/time.dart';

class OtpItem extends StatefulWidget {
  late final Otp otp;

  //const OtpItem({Key? key}) : super(key: key);

  OtpItem(this.otp, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OtpItemState();
}

class _OtpItemState extends State<OtpItem> with TickerProviderStateMixin {
  late Timer updateTimer;
  var _progress = 0.0;
  var _isShowing = false;
  var _otpCode = '';

  void tapToReveal() {
    setState(() {
      _otpCode = widget.otp.getCode();
      _isShowing = !_isShowing;
    });
  }

  void updateProgress() {
    var period = widget.otp.period * 1000;
    var timeLeft = Time.getTimeLeftInPeriod(period);
    var progress = 1 - timeLeft / period;

    setState(() {
      _progress = progress;
    });
  }

  @override
  void initState() {
    updateProgress();
    updateTimer = Timer.periodic(
        Duration(milliseconds: 10), (Timer t) => {updateProgress()});
    print(updateTimer.isActive);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateProgress();

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
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                SizedBox(
                                    child: Text(_otpCode,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    width: 100),
                                SizedBox(
                                    child: LinearProgressIndicator(
                                        value: _progress,
                                        backgroundColor: Colors.pink,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white)),
                                    height: 3,
                                    width: 100),
                              ])
                        : IconButton(
                            onPressed: tapToReveal,
                            icon: const Icon(
                              Icons.touch_app_sharp,
                              color: Colors.pink,
                              size: 30,
                            ))),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
