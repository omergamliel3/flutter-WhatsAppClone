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
  bool _isLight; // theme mode
  Stream<QuerySnapshot> _statusStream; // status stream

  @override
  initState() {
    // get theme mode from main model
    _isLight = context.read<MainModel>().isLight;
    // set status stream to firestore snapshots
    _statusStream = FirebaseFirestore.instance
        .collection('users_status')
        .orderBy('timestamp', descending: true)
        .snapshots();
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
    bool allowDelete = status.userName.toLowerCase().trim() ==
        PrefsService.userName.toLowerCase().trim();
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
      // only user can delete its own status
      onTap: allowDelete ? () => _handleDeleteStatus(status) : null,
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
      stream: _statusStream,
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
            Status status = Status.fromJsonMap(
                snapshot.data.docs[index].data(), snapshot.data.docs[index].id);
            return _buildStatusListTile(status);
          },
        ));
      },
    );
  }

  // delete status, update latest user status
  void _handleDeleteStatus(Status status) async {
    await FirestoreService.deleteStatus(status);
    String updatedStatus =
        await FirestoreService.getUserStatus(PrefsService.userName);
    context.read<MainModel>().updateUserStatus(updatedStatus);
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
