import 'package:flutter/material.dart';

// main app bar popupmenu button widget class

class PopUpMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: 'More',
      icon: const Icon(Icons.more_vert),
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
              value: 0,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'New group',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          PopupMenuItem<int>(
              value: 1,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'New broadcast',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          PopupMenuItem<int>(
              value: 2,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'WhatsApp Web',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          PopupMenuItem<int>(
              value: 3,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Starred messages',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          PopupMenuItem<int>(
              value: 4,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
        ];
      },
    );
  }
}
