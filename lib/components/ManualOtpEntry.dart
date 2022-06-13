import 'package:flutter/material.dart';
import '../service/popup.dart';

class ManualOtpEntry {
  late final Widget _form;
  final TextEditingController _issuerController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _secretController = TextEditingController();
  late final Function(String, String, String) _callback;

  /// Constructor.
  ManualOtpEntry._(Function(String, String, String) onClose) {
    // Set callback.
    _callback = onClose;

    // Create form widget.
    _form = Form(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
                decoration: const InputDecoration(
                  labelText: 'Issuer',
                  hintText: 'e.g. Google',
                ),
                controller: _issuerController,
                autofocus: true),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Account', hintText: 'name@example.com'),
              controller: _labelController,
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Secret', hintText: 'Your key'),
              controller: _secretController,
            ),
          ],
        ),
      ),
    );
  }

  /// Show the form. OnClose function will use the values in this order: [_issuer], [_label], [_secret].
  static void showForm(
      BuildContext context, Function(String, String, String) onClose) {
    final moe = ManualOtpEntry._(onClose);
    Popup.simpleDialog('Manual input', moe._form, context,
        onClose: moe._formCallback);
  }

  /// Callback for the form.
  void _formCallback() {
    final issuer = _issuerController.text;
    final label = _labelController.text;
    final secret = _secretController.text;
    _callback(issuer, label, secret);
  }
}
