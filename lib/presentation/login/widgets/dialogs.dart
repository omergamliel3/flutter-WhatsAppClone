// show user is taken dialog
import 'package:flutter/material.dart';

void showUserIsTakenDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Username is taken'.toUpperCase()),
        content: const Text('Please enter another username'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}

void showNoConnectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('THERE IS NO INTERNET CONNECTION'),
        content: const Text('Please connect your device to network'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}

// show authentication failed dialog
void showFailedAuthDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Phone auth failed'),
        content: const Text('Please validate your phone number'),
        actions: [
          FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).accentColor),
              ))
        ],
      );
    },
  );
}
