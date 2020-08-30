import 'package:flutter/material.dart';

import 'package:WhatsAppClone/services/contacts_service.dart';

import 'package:contacts_service/contacts_service.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with AutomaticKeepAliveClientMixin {
  List<Contact> contactsData = ContactsHandler.contactsData;
  // build contact list tile widget
  Widget _buildContactListTile(Contact contact) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          contact.givenName[0].toUpperCase() ?? '',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey,
      ),
      title: Text(contact.displayName),
      subtitle: Text('Last message'),
      trailing: Text('19:13'),
      dense: true,
      onTap: () {
        print('nativage call private chat');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: ContactsHandler.length == 0
            ? Container()
            : ListView.separated(
                physics: ScrollPhysics(),
                itemCount: ContactsHandler.length,
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 70.0),
                    child: Divider(
                      thickness: 1.0,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  return _buildContactListTile(contactsData[index]);
                }));
  }

  @override
  bool get wantKeepAlive => true;
}
