import 'package:airauth/providers/otp_provider.dart';
import 'package:airauth/service/error_data.dart';
import 'package:airauth/service/popup.dart';
import 'package:airauth/service/time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class QRReaderPage extends StatefulWidget {
  const QRReaderPage({Key? key}) : super(key: key);

  @override
  State<QRReaderPage> createState() => _QRReaderPageState();
}

class _QRReaderPageState extends State<QRReaderPage> {
  // Is a QR code being evaluated right now.
  var _isProcessingQr = false;
  int _lastSnackbar = 0;

  /// Add a scanned otp to the server.
  Future<void> _addScannedOtp(String? value) async {
    try {
      // Check if evaluation should be stopped.
      if (_isProcessingQr || value == null) return;
      _isProcessingQr = true;

      // Add otp to server.
      final provider = Provider.of<OtpProvider>(context, listen: false);
      await provider.handleQRCode(value);

      // Go back to home page.
      _goBack();
    } catch (e) {
      // Only show snackbar if it was not shown in the last 5 seconds.
      _isProcessingQr = false;
      final now = Time.getTime();
      if (now - _lastSnackbar < 5000) return;
      _lastSnackbar = now;

      // Show snackbar.
      final error = ErrorData.handleException(e);
      Popup.showSnackbar(error.message, context);
    }
  }

  /// Go back to home page.
  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Define screen size.
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
            // Top dark box with exit button.
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

            // Middle row with transparent box in middle.
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

            // Bottom dark box.
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
