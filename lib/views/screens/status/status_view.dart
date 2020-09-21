import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/provider/main.dart';
import '../../../core/models/status.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../../utils/datetime.dart';

import '../../../core/widgets/ui_elements/status_modal_bottom_sheet.dart';
import 'status_viewmodel.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage>
    with AutomaticKeepAliveClientMixin {
  // build personal status listile
  Widget _buildPersonalStatus(StatusViewModel model) {
    return Selector<MainModel, String>(
        selector: (context, model) => model.userStatus,
        builder: (context, value, child) {
          var _isLight = Theme.of(context).brightness == Brightness.light;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  _isLight ? Theme.of(context).primaryColor : Colors.blue,
              child: Text(
                model.username[0].toUpperCase(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text('My status'),
            subtitle: Text(value ?? 'Tap to add status update'),
            onTap: () {
              // show status modal bottom sheet
              showStatusModalBottomSheet(context);
            },
          );
        });
  }

  // build users status widget
  Widget _buildStatus(Status status, StatusViewModel model) {
    var timeAgo = formatDateTime(status.timestamp);
    var allowDelete = model.allowDelete(status.userName);
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
      // only user can delete its own status
      onTap:
          allowDelete ? () => model.handleDeleteStatus(status, context) : null,
    );
  }

  // build divider text widget
  Widget _buildDividerText(StatusViewModel model) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 6, 0, 6),
        alignment: Alignment.centerLeft,
        child: Text('Recent updates'));
  }

  // build users status widgets from firestore collection snapthots
  Widget _buildUsersStatus(StatusViewModel model) {
    return StreamBuilder<QuerySnapshot>(
      stream: model.statusStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error);
        }

        return Expanded(
            child: Scrollbar(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var status = Status.fromJsonMap(snapshot.data.docs[index].data(),
                  snapshot.data.docs[index].id);
              return _buildStatus(status, model);
            },
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<StatusViewModel>.nonReactive(
      viewModelBuilder: () => StatusViewModel(),
      onModelReady: (model) => model.initalise(),
      builder: (context, model, child) {
        return Scaffold(
            body: Column(
          children: [
            _buildPersonalStatus(model),
            _buildDividerText(model),
            _buildUsersStatus(model)
          ],
        ));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
