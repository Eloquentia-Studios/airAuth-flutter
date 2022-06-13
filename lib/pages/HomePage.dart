import 'dart:async';

import 'package:airauth/components/OtpItem.dart';
import 'package:airauth/models/Otp.dart';
import 'package:airauth/providers/otp_provider.dart';
import 'package:airauth/service/authentication.dart';
import 'package:airauth/service/otps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/ManualOtpEntry.dart';
import '../service/popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BuildContext _context;

  @override
  void initState() {
    super.initState();
    _updateOtpItems();
  }

  /// Update local otp storage.
  Future<void> _updateOtpItems() async {
    try {
      // Load otp items from server.
      await Otps.updateOpts();
      final otpProvider = Provider.of<OtpProvider>(_context, listen: false);
      otpProvider.clear();
      otpProvider.addAll(await Otps.getOpts());
    } catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: const Text('Failed to get OTP items from server.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Color.fromARGB(202, 0, 0, 0),
        ),
      );
    }
  }

  /// Go to QR reader page.
  void _scanQR() {
    Navigator.pushNamed(_context, '/qrreader');
  }

  void _manualInput() {
    final callback = (String issuer, String label, String secret) async {
      try {
        String otpUrl = Otps.generateOtpUrl(issuer, label, secret);
        await Otps.addOtp(otpUrl);
        await Otps.updateOpts();
        final provider = Provider.of<OtpProvider>(_context, listen: false);
        provider.clear();
        provider.addAll(await Otps.getOpts());
      } catch (e) {
        // Show snackbar with error.
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(
            content: Text('Failed to add OTP.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Color.fromARGB(202, 0, 0, 0),
          ),
        );
      }
    };

    // Show manual input form.
    final manualOtpEntry = ManualOtpEntry.showForm(_context, callback);
  }

  /// Sign out of the app.
  void _signOut() async {
    await Authentication.signOut();
    Navigator.pushReplacementNamed(_context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final otpWidgets = Provider.of<OtpProvider>(context).getOtpItems();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case 'add_qr':
                    _scanQR();
                    break;
                  case 'add_manual':
                    _manualInput();
                    break;
                  case 'sign_out':
                    _signOut();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'add_qr',
                  child: Text('Scan QR'),
                ),
                const PopupMenuItem(
                  value: 'add_manual',
                  child: Text('Manual code'),
                ),
                const PopupMenuItem(value: 'settings', child: Text('Settings')),
                const PopupMenuItem(value: 'sign_out', child: Text('Sign out')),
              ],
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(5),
          child: Center(
              child: RefreshIndicator(
                  child: ListView(children: otpWidgets),
                  onRefresh: _updateOtpItems)),
        ));
  }
}
