import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/models/status.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

import 'package:WhatsAppClone/core/widgets/ui_elements/status_modal_bottom_sheet.dart';

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
        // show status modal bottom sheet
        showStatusModalBottomSheet(context);
      },
    );
  }

  // build users status widget
  Widget _buildStatusListTile(Status status) {
    String timeAgo = timeago.format(status.dateTime);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          status.name[0].toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(status.name),
      subtitle: Text(
        status.content,
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

        // sort snapshot data
        List<QueryDocumentSnapshot> sortedSnapshot =
            sortSnapshot(snapshot.data.docs);

        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              Status status = Status.fromJsonMap(sortedSnapshot[index].data());
              return _buildStatusListTile(status);
            },
          ),
        );
      },
    );
  }

  // sort snapshot db collection data according to datetime (newest first, oldest last)
  List<QueryDocumentSnapshot> sortSnapshot(
      List<QueryDocumentSnapshot> snapshotDataDocs) {
    snapshotDataDocs.sort((a, b) => DateTime.parse(a.data()['datetime'])
        .compareTo(DateTime.parse(b.data()['datetime'])));
    return snapshotDataDocs.reversed.toList();
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
