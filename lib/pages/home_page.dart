import 'dart:async';
import 'package:airauth/components/edit_otp.dart';
import 'package:airauth/components/otp_item.dart';
import 'package:airauth/providers/otp_provider.dart';
import 'package:airauth/service/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/manual_otp_entry.dart';
import '../service/popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BuildContext _context;
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getLocalOtpItems() async {
    final otpProvider = Provider.of<OtpProvider>(_context, listen: false);
    await otpProvider.getLocalOtpItems();
  }

  /// Fetch latest OTPs from server.
  Future<void> _updateOtpItemsFromServer() async {
    try {
      final otpProvider = Provider.of<OtpProvider>(_context, listen: false);
      await otpProvider.updateFromServer();
    } catch (e) {
      // Display error message.
      Popup.showSnackbar('Failed to load OTP items from server.', _context);
    }
  }

  /// Go to QR reader page.
  void _scanQR() {
    Navigator.pushNamed(_context, '/qrreader');
  }

  /// Handle manual OTP entry.
  void _handleManualInputForm(
      String issuer, String label, String secret) async {
    try {
      final otpProvider = Provider.of<OtpProvider>(_context, listen: false);
      await otpProvider.addToServer(issuer, label, secret);
    } catch (e) {
      Popup.showSnackbar('Failed to add OTP.', context);
    }
  }

  /// Handle updating of an OTP.
  Future<void> _handleOtpUpdate(
      OtpItem item, String? newIssuer, String? newLabel) async {
    try {
      // Make empty strings null.
      if (newIssuer == '') newIssuer = null;
      if (newLabel == '') newLabel = null;

      final otpProvider = Provider.of<OtpProvider>(_context, listen: false);
      await otpProvider.updateOnServer(item.otp.getId(),
          customIssuer: newIssuer, customLabel: newLabel);
    } catch (e) {
      Popup.showSnackbar('Failed to update OTP.', context);
    }
  }

  /// Open manual OTP entry form.
  void _manualInput() {
    ManualOtpEntry.showForm(_context, _handleManualInputForm);
  }

  /// Sign out of the app.
  void _signOut() async {
    await Authentication.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(_context, '/signin');
  }

  /// Handle OTP item dismissal.
  Future<bool> _dismissItem(DismissDirection direction, OtpItem item) async {
    // Delete item when swiped right to left.
    if (direction == DismissDirection.endToStart) {
      // Confirm deletion.
      final answer = await Popup.confirm(
          'Are you sure?',
          'Do you want to delete ${item.otp.getLabel()} ${item.otp.getIssuer()}?',
          context);

      // Delete item if confirmed.
      if (answer) {
        if (!mounted) return false;
        final otpProvider = Provider.of<OtpProvider>(_context, listen: false);
        await otpProvider.deleteFromServer(item.otp.getId());
      }

      return answer;
    }

    // Edit item when swiped left to right.
    if (direction == DismissDirection.startToEnd) {
      EditOtp.showForm(context, item.otp.getIssuer(), item.otp.getLabel(),
          (newIssuer, newLabel) => _handleOtpUpdate(item, newIssuer, newLabel));
    }
    return false;
  }

  /// Handle menu item selection.
  void _handleMenu(String value) {
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
  }

  @override
  Widget build(BuildContext context) {
    // Update context.
    _context = context;

    // Update OTP items from server on first load.
    if (firstLoad) {
      firstLoad = false;
      _getLocalOtpItems();
      _updateOtpItemsFromServer();
    }

    // Get all OTP items from provider.
    final otpProvider = Provider.of<OtpProvider>(context);
    final otpWidgets = otpProvider.getOtpItems();

    return Scaffold(
        appBar: AppBar(
          title: const Text('airAuth'),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              onSelected: _handleMenu,
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
            onRefresh: _updateOtpItemsFromServer,
            child: ListView.builder(
              itemCount: otpWidgets.length,
              itemBuilder: (context, index) {
                final item = otpWidgets[index];
                return Dismissible(
                  key: Key(item.otp.getId()),
                  confirmDismiss: (DismissDirection direction) async =>
                      await _dismissItem(direction, item),
                  onDismissed: (DismissDirection direction) =>
                      _updateOtpItemsFromServer,
                  background: Container(
                      color: Colors.green,
                      child: Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 0,
                          runSpacing: 0,
                          runAlignment: WrapAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Wrap(
                                    direction: Axis.vertical,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      Text('Edit')
                                    ]))
                          ])),
                  secondaryBackground: Container(
                      color: Colors.red,
                      child: Wrap(
                          alignment: WrapAlignment.end,
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 0,
                          runSpacing: 0,
                          runAlignment: WrapAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Wrap(
                                    direction: Axis.vertical,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      Text('Delete')
                                    ]))
                          ])),
                  child: item,
                );
              },
            ),
          )),
        ));
  }
}
