import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:WhatsAppClone/services/device/contacts_service.dart';
import 'package:WhatsAppClone/services/local_storage/db_service.dart';

import 'package:WhatsAppClone/core/models/chat.dart';
import 'package:WhatsAppClone/core/provider/main.dart';

import 'package:WhatsAppClone/core/shared/constants.dart';

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
  Widget _buildContactListTile(String displayName, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(displayName[0].toUpperCase(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey,
        ),
        title: Text(displayName),
        trailing: _contactMode == ContactMode.Chat
            ? SizedBox()
            : IconButton(icon: Icon(Icons.phone), onPressed: () {}),
        onTap: _contactMode == ContactMode.Chat
            ? () {
                _createNewChat(displayName, context);
              }
            : null,
      ),
    );
  }

  // create new chat
  void _createNewChat(String displayName, BuildContext context) async {
    // new empty chat instance
    final Chat chat = Chat(name: displayName, messages: '', timestamp: '');
    // create new chat in db chats table
    await DBservice.createChat(chat);
    // get active chats in main model to update UI
    await context.read<MainModel>().getActiveChats(notify: true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                  ContactsHandler.contactsData[index].displayName, context);
            }),
      ),
    );
  }
}
