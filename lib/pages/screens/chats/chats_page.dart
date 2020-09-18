import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/models/contact_entity.dart';
import '../../../core/provider/main.dart';

import '../../../helpers/navigator_helper.dart';
import '../../../helpers/datetime.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with AutomaticKeepAliveClientMixin {
  Widget _buildEmptyContact() {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: Text(
          'No active contacts',
          style: Theme.of(context).textTheme.headline5,
        ));
  }

  // build contact list tile widget
  Widget _buildContactListTile(ContactEntity contactEntity, int index) {
    var name = contactEntity.displayName ?? 'unKnown';
    var lastMessage =
        contactEntity.lastMsg == 'null' ? '' : contactEntity.lastMsg;
    var timeAgo = contactEntity.lastMsgTime == null
        ? ''
        : formatDateTime(contactEntity.lastMsgTime);

    return ListTile(
      leading: CircleAvatar(
        child: Text(
          name[0],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey,
      ),
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: Text(timeAgo),
      onTap: () {
        Routes.navigatePrivateChatSceen(context, contactEntity);
      },
    );
  }

  // build contact chats listview
  Widget _buildContactChats() {
    return Selector<MainModel, List<ContactEntity>>(
      selector: (context, model) => model.activeContacts,
      builder: (context, data, child) {
        // order contacts data by date time decending
        var contacts = data;
        if (contacts.isEmpty) {
          return _buildEmptyContact();
        }
        contacts.sort((a, b) => a.lastMsgTime.compareTo(b.lastMsgTime));
        contacts = contacts.reversed.toList();

        return ListView.separated(
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 70.0, right: 10),
                child: Divider(thickness: 2.0),
              );
            },
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return _buildContactListTile(contacts[index], index);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _buildContactChats(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
