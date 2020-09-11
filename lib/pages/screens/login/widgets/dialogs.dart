// show user is taken dialog
import 'package:flutter/material.dart';

void showUserIsTakenDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Username is taken'.toUpperCase()),
        content: Text('Please enter another username'),
        actions: [
          FlatButton(child: Text('OK'), onPressed: () => Navigator.pop(context))
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
        title: Text('Phone auth failed'),
        content: Text('Please validate your phone number'),
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
