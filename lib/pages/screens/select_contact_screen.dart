import 'package:flutter/material.dart';

import 'package:WhatsAppClone/services/device/contacts_service.dart';

import 'package:WhatsAppClone/core/constants.dart';

class SelectContactScreen extends StatelessWidget {
  //
  final ContactMode _contactMode;
  SelectContactScreen(this._contactMode);

  // build appbar title
  Widget _buildAppBarTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select contact'),
        SizedBox(height: 3.0),
        Text(
          '${ContactsHandler.contactsData.length.toString()} contacts',
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  // build PopupMenuButton
  PopupMenuButton _buildPopUpMenuButton() {
    return PopupMenuButton(
      tooltip: 'More',
      icon: Icon(Icons.more_vert),
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
              value: 0,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Invite a friend',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          PopupMenuItem<int>(
              value: 1,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Contacts',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          PopupMenuItem<int>(
              value: 2,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Refresh',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          PopupMenuItem<int>(
              value: 3,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Help',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
        ];
      },
      onSelected: (value) {
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
      },
    );
  }

  // build contact list tile
  Widget _buildContactListTile(String displayName) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: CircleAvatar(
          //backgroundImage: MemoryImage(contact.avatar),
          backgroundColor: Colors.blue,
        ),
        title: Text(displayName),
        trailing: _contactMode == ContactMode.Chat
            ? SizedBox()
            : IconButton(icon: Icon(Icons.phone), onPressed: () {}),
        onTap: _contactMode == ContactMode.Chat
            ? () {
                print('add contact to chat page');
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_contactMode);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: _buildAppBarTitle(context),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            _buildPopUpMenuButton()
          ],
        ),
        body: ListView.builder(
            physics: ScrollPhysics(),
            itemCount: ContactsHandler.contactsData.length,
            itemBuilder: (context, index) {
              return _buildContactListTile(
                  ContactsHandler.contactsData[index].displayName);
            }),
      ),
    );
  }
}
