import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with AutomaticKeepAliveClientMixin {
  Future<Iterable<Contact>> _future;
  @override
  initState() {
    _future = ContactsService.getContacts(orderByGivenName: false);
    super.initState();
  }

  // build contact list tile widget
  Widget _buildContactListTile(Contact contact) {
    return ListTile(
      leading: CircleAvatar(
        //backgroundImage: MemoryImage(contact.avatar),
        backgroundColor: Colors.blue,
      ),
      title: Text(contact.displayName),
      subtitle: Text('Last message'),
      trailing: Text('timeago'),
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
        body: FutureBuilder<Iterable<Contact>>(
      future: _future,
      builder:
          (BuildContext context, AsyncSnapshot<Iterable<Contact>> snapshot) {
        if (snapshot.hasData) {
          List<Contact> contactsData = snapshot.data.toList();
          if (contactsData.length == 0) {
            return Container(
                padding: EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                child: Text(
                  'THERE ARE NO SAVED CONTACTS',
                  style: Theme.of(context).textTheme.headline6,
                ));
          }
          return ListView.separated(
              physics: ScrollPhysics(),
              itemCount: contactsData.length,
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 70.0),
                  child: Divider(
                    thickness: 1.5,
                  ),
                );
              },
              itemBuilder: (context, index) {
                return _buildContactListTile(contactsData[index]);
              });
        }

        return Center(child: CircularProgressIndicator());
      },
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
