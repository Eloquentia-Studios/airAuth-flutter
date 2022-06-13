import 'dart:async';
import 'dart:ui';

import 'package:airauth/models/Otp.dart';
import 'package:airauth/service/otps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool _notDisposed = true;
  var _progress = 0.0;
  var _isShowing = false;
  var _otpCode = '';
  late BuildContext _context;

  void tapToReveal() {
    setState(() {
      final code = widget.otp.getCode();
      _otpCode = Otps.formatOtp(code);
      _isShowing = !_isShowing;
    });
  }

  void updateProgress() {
    var period = widget.otp.period * 1000;
    var timeLeft = Time.getTimeLeftInPeriod(period);
    var progress = 1 - timeLeft / period;
    if (progress > _progress) {
      final code = widget.otp.getCode();
      _otpCode = Otps.formatOtp(code);
    }

    if (_notDisposed) {
      setState(() {
        _progress = progress;
      });
    }
  }

  @override
  void initState() {
    updateProgress();
    updateTimer = Timer.periodic(
        Duration(milliseconds: 10), (Timer t) => {updateProgress()});
    print(updateTimer.isActive);
    super.initState();
  }

  /// Copy otp code to clipboard.
  void copyCode() {
    final otpCode = widget.otp.getCode().trim();
    Clipboard.setData(ClipboardData(text: otpCode));

    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard.'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Color.fromARGB(202, 0, 0, 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    updateProgress();
    _context = context;

    return Center(
        child: Card(
            child: InkWell(
                onLongPress: copyCode,
                onTap: tapToReveal,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                        SizedBox(
                                            width: 100,
                                            child: Text(_otpCode,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500,
                                                ))),
                                        SizedBox(
                                            height: 3,
                                            width: 100,
                                            child: LinearProgressIndicator(
                                                value: _progress,
                                                backgroundColor: Colors.pink,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(Colors.white))),
                                      ])
                                : const Icon(
                                    Icons.touch_app_sharp,
                                    color: Colors.pink,
                                    size: 30,
                                  )),
                      ],
                    ),
                  ),
                ]))));
  }

  @override
  void dispose() {
    _notDisposed = false;
    updateTimer.cancel();
    super.dispose();
  }
}
