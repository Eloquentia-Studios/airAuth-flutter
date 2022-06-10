import 'package:airauth/components/OtpItem.dart';
import 'package:airauth/providers/otp_provider.dart';
import 'package:airauth/service/otps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    _context = context;
    final otpWidgets = Provider.of<OtpProvider>(context).otpItems;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if (value == 'add_qr') {
                  _scanQR();
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
                const PopupMenuItem(value: 'settings', child: Text('Settings'))
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
