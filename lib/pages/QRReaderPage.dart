import 'package:airauth/service/otps.dart';
import 'package:airauth/service/validation.dart';
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class QRReaderPage extends StatefulWidget {
  const QRReaderPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _QRReaderPageState createState() => _QRReaderPageState();
}

class _QRReaderPageState extends State<QRReaderPage> {
  var _isProcessingQr = false;

  /// Add a scanned otp to the server.
  Future<void> _addScannedOtp(String? value) async {
    try {
      if (_isProcessingQr) return;
      if (value == null) return;
      _isProcessingQr = true;

      if (!Validation.validOTPUrl(value)) throw Exception('Invalid OTP URL.');
      await Otps.addOtp(value);
      await Otps.updateOpts();
      Navigator.pop(context);
    } catch (e) {
      _isProcessingQr = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to add OTP.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Color.fromARGB(202, 0, 0, 0),
        ),
      );
    }
  }

  /// Go back to home page.
  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final boxSize = width * 0.7;
    final halfBoxSize = boxSize * 0.5;

    return Scaffold(
        body: Stack(children: [
      SizedBox(
        width: width,
        height: height,
        child: QrCamera(
          qrCodeCallback: _addScannedOtp,
        ),
      ),
      SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              width: width,
              height: height / 2 - halfBoxSize,
              color: const Color.fromARGB(100, 0, 0, 0),
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 50,
                height: statusBarHeight * 2 + 50,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 35,
                    color: Color.fromARGB(255, 225, 225, 225),
                  ),
                  onPressed: _goBack,
                ),
              ),
            ),
            Row(children: [
              Container(
                width: width / 2 - halfBoxSize,
                height: boxSize,
                color: const Color.fromARGB(100, 0, 0, 0),
              ),
              Container(
                width: boxSize,
                height: boxSize,
                color: const Color.fromARGB(0, 0, 0, 0),
              ),
              Container(
                width: width / 2 - halfBoxSize,
                height: boxSize,
                color: const Color.fromARGB(100, 0, 0, 0),
              ),
            ]),
            Container(
              width: width,
              height: height / 2 - halfBoxSize,
              color: const Color.fromARGB(100, 0, 0, 0),
              child: Column(children: [
                SizedBox(width: width, height: 20),
                const Center(
                  child: Text(
                    'Scan QR code',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      )
    ]));
  }
}
