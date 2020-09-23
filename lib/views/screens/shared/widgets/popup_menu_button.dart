import 'package:flutter/material.dart';

class PopUpMenuButton extends StatelessWidget {
  final List<String> buttons = [
    'Invite a friend',
    'Contacts',
    'Refresh',
    'Help'
  ];
  // handle button functions
  void _onSelected(int value) {
    switch (value) {
      case 0:
        // Share package implement
        break;
      case 1:
        // Andrid intent contacts launch
        break;
      case 2:
        // Refresh contacts
        break;
      case 3:
        // navigate help page
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: 'More',
      icon: Icon(Icons.more_vert),
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        return buttons.map((e) {
          var index = buttons.indexOf(e);
          return PopupMenuItem<int>(
              value: index,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    buttons[index],
                    style: Theme.of(context).textTheme.bodyText1,
                  )));
        }).toList();
      },
      onSelected: _onSelected,
    );
  }
}
