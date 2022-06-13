import 'package:flutter/material.dart';

class Popup {
  /// Show a popup message.
  static void show(String title, String message, BuildContext context) {
    alertDialog(title, Text(message), context);
  }

  /// Show any widget as a alert dialog.
  static void alertDialog(String title, Widget widget, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: widget,
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Show any widget as a simple dialog.
  static void simpleDialog(String title, Widget widget, BuildContext context,
      {Function? onClose}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(title),
          children: <Widget>[
            widget,
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                if (onClose != null) {
                  onClose();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Confirm a question.
  static Future<bool> confirm(
      String title, String message, BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
