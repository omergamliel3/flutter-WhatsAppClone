import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'select_contact_viewmodel.dart';

import '../../../core/models/contact_entity.dart';

import '../../../core/shared/constants.dart';

class SelectContactScreen extends StatelessWidget {
  final ContactMode _contactMode;
  SelectContactScreen(this._contactMode);

  // build appbar title
  Widget _buildAppBarTitle(BuildContext context, int contactsLength) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select contact'),
        SizedBox(height: 3.0),
        Text(
          '${contactsLength.toString()} contacts',
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: Colors.grey[300]),
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
  Widget _buildContactListTile(ContactEntity contactEntity,
      BuildContext context, SelectContactViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(contactEntity.displayName[0].toUpperCase(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey,
        ),
        title: Text(contactEntity.displayName),
        trailing: _contactMode == ContactMode.chat
            ? SizedBox()
            : IconButton(icon: Icon(Icons.phone), onPressed: () {}),
        onTap: _contactMode == ContactMode.chat
            ? () async {
                // create new contact entity
                await model.createContactEntity(contactEntity, context);
                Navigator.pop(context);
              }
            : null,
      ),
    );
  }

  // build scaffold appbar
  Widget _buildAppBar(context, contacts) {
    return AppBar(
      title: _buildAppBarTitle(context, contacts.length),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        _buildPopUpMenuButton(),
        SizedBox(
          width: 4.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectContactViewModel>.nonReactive(
      viewModelBuilder: () => SelectContactViewModel(),
      builder: (context, model, child) {
        var contacts = model.getUnActiveContacts(context);
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: _buildAppBar(context, contacts),
            body: Scrollbar(
              child: ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return _buildContactListTile(
                        contacts[index], context, model);
                  }),
            ),
          ),
        );
      },
    );
  }
}
