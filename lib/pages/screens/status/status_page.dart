import 'package:WhatsAppClone/core/provider/main.dart';
import 'package:WhatsAppClone/services/firebase/firestore_service.dart';
import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/models/status.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

import 'package:WhatsAppClone/core/widgets/ui_elements/status_modal_bottom_sheet.dart';

class StatusPage extends StatefulWidget {
  // build user status listile
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage>
    with AutomaticKeepAliveClientMixin {
  bool _isLight;
  @override
  initState() {
    _isLight = context.read<MainModel>().isLight;
    super.initState();
  }

  // build personal status listile
  Widget _buildPersonalStatus() {
    return Selector<MainModel, String>(
        selector: (context, model) => model.userStatus,
        builder: (context, value, child) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  _isLight ? Theme.of(context).primaryColor : Colors.blue,
              child: Text(
                PrefsService.userName[0].toUpperCase(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text('My status'),
            subtitle: Text(value ?? 'Tap to add status update'),
            dense: true,
            onTap: () {
              // show status modal bottom sheet
              showStatusModalBottomSheet(context);
            },
          );
        });
  }

  // build users status widget
  Widget _buildStatusListTile(Status status) {
    String timeAgo = timeago.format(status.timestamp);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          status.userName[0].toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(status.userName),
      subtitle: Text(
        status.content,
      ),
      trailing: Text(
        timeAgo,
        style: Theme.of(context).textTheme.caption,
      ),
      dense: true,
      onTap: status.userName == PrefsService.userName
          ? () async {
              bool delete = await FirestoreService.deleteStatus(status);
              if (delete) {
                //setState(() {});
              }
            }
          : null,
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
            Status status = Status.fromJsonMap(
                sortedSnapshot[index].data(), sortedSnapshot[index].id);
            return _buildStatusListTile(status);
          },
        ));
      },
    );
  }

  // sort snapshot db collection data according to datetime (newest first)
  List<QueryDocumentSnapshot> sortSnapshot(
      List<QueryDocumentSnapshot> snapshotDataDocs) {
    snapshotDataDocs.sort((a, b) => DateTime.parse(a.data()['timestamp'])
        .compareTo(DateTime.parse(b.data()['timestamp'])));
    return snapshotDataDocs.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Column(
      children: [
        _buildPersonalStatus(),
        _buildDividerText(),
        _buildUsersStatus()
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
