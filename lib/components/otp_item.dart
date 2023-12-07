import 'dart:async';

import 'package:airauth/models/Otp.dart';
import 'package:airauth/service/otps.dart';
import 'package:airauth/service/popup.dart';
import 'package:airauth/service/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpItem extends StatefulWidget {
  final Otp otp;

  const OtpItem(this.otp, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OtpItemState();
}

class _OtpItemState extends State<OtpItem> with TickerProviderStateMixin {
  // Code & progress update timer.
  late Timer _updateTimer;

  // TOTP period progress.
  var _progress = 0.0;

  // OTP code showing.
  var _isShowing = false;

  // OTP code.
  var _otpCode = '';

  // Component build context.
  late BuildContext _context;

  /// Toggle showing otp code.
  void _tapToReveal() {
    _updateOtpCode();
    setState(() {
      _isShowing = !_isShowing;
    });
  }

  /// Update otp code and progress.
  void _updateProgress() {
    // Calculate progress.
    var period = widget.otp.getPeriod() * 1000;
    var timeLeft = Time.getTimeLeftInPeriod(period);
    var progress = 1 - (timeLeft / period);

    // Update otp code after each period.
    if (progress < _progress) _updateOtpCode();

    // Update progress if not disposed.
    if (!mounted) return;
    setState(() {
      _progress = progress;
    });
  }

  /// Update otp code.
  void _updateOtpCode() {
    final code = widget.otp.getCode();
    _otpCode = Otps.formatOtp(code);
  }

  @override
  void initState() {
    // Update otp code and progress.
    _updateProgress();
    _updateTimer = Timer.periodic(
        const Duration(milliseconds: 10), (Timer t) => _updateProgress());

    super.initState();
  }

  /// Copy otp code to clipboard.
  void copyCode() {
    final otpCode = widget.otp.getCode().trim();
    Clipboard.setData(ClipboardData(text: otpCode));
    Popup.showSnackbar('Copied to clipboard.', _context);
  }

  @override
  Widget build(BuildContext context) {
    // Update context.
    _context = context;

    // Detect color theme.
    final theme = Theme.of(context);

    return Center(
        child: Card(
            child: InkWell(
                onLongPress: copyCode,
                onTap: _tapToReveal,
                child: Row(children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title: Text(widget.otp.getIssuer()),
                          subtitle: Text(widget.otp.getLabel()),
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
                                                backgroundColor:
                                                    theme.iconTheme.color,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        theme.cardTheme
                                                            .color!))),
                                      ])
                                : Icon(
                                    Icons.touch_app_sharp,
                                    color: theme.iconTheme.color,
                                    size: 30,
                                  )),
                      ],
                    ),
                  ),
                ]))));
  }

  @override
  void dispose() {
    // Cancel update timer.
    _updateTimer.cancel();

    super.dispose();
  }
}
