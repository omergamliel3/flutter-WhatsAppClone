import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:WhatsAppClone/services/prefs_service.dart';

class StatusPage extends StatefulWidget {
  // build user status listile
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  // build personal status listile
  Widget _buildPersonalStatus() {
    bool isLight = Theme.of(context).brightness == Brightness.light;
    String userStatus = PrefsService.userStatus ?? 'Tap to add status update';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isLight ? Theme.of(context).primaryColor : Colors.blue,
        child: Text(
          PrefsService.userName[0].toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text('My status'),
      subtitle: Text(userStatus),
      dense: true,
      onTap: () {
        updateNewStatus();
      },
    );
  }

  // build users status widget
  Widget _buildStatusListTile(Map<String, dynamic> statusDoc) {
    String name = statusDoc['name'];
    String status = statusDoc['status'];
    DateTime datetime = DateTime.parse(statusDoc['datetime']);
    String timeAgo = timeago.format(datetime);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          name[0].toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(name),
      subtitle: Text(
        status,
      ),
      trailing: Text(
        timeAgo,
        style: Theme.of(context).textTheme.caption,
      ),
      dense: true,
    );
  }

  // build divider text widget
  Widget _buildDividerText() {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 6, 0, 6),
        alignment: Alignment.centerLeft,
        child: Text('Recent updates'));
  }

  // build users status widgets from firestore collection snapthots
  Widget _buildUsersStatus() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users_status').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return _buildStatusListTile(snapshot.data.docs[index].data());
            },
          ),
        );
      },
    );
  }

  void updateNewStatus() async {
    try {
      var docRef =
          await FirebaseFirestore.instance.collection('users_status').add({
        'name': PrefsService.userName,
        'status': 'I love flutter!!!',
        'datetime': DateTime.now().toIso8601String()
      });
      print('created new firestore recored with id: ${docRef.id}');
    } catch (e) {
      print('failed to add new record to firestoe');
      print(e);
    }
    setState(() {
      PrefsService.saveUserStatus(status: 'I love flutter!!!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _buildPersonalStatus(),
        _buildDividerText(),
        _buildUsersStatus()
      ],
    ));
  }
}
