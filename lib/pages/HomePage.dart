import 'package:airauth/components/OtpItem.dart';
import 'package:airauth/service/otps.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var otpWidgets = <Widget>[];
  late BuildContext _context;

  @override
  void initState() {
    super.initState();
    _updateOtpWidgets();
    _updateOtpItems();
  }

  /// Update local otp storage.
  Future<void> _updateOtpItems() async {
    try {
      // Load otp items from server.
      await Otps.updateOpts();
      _updateOtpWidgets();
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

  /// Load from local otp storage.
  void _updateOtpWidgets() async {
    // Load otp items from storage.
    final otpItems = await Otps.getOpts();

    // Update otp widgets.
    setState(() {
      otpWidgets = otpItems.map((otp) => OtpItem(otp)).toList();
    });
  }

  /// Go to QR reader page.
  void _addOTP() {
    Navigator.pushNamed(_context, '/qrreader');
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addOTP,
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
