import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../core/models/status.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/datetime.dart';

import '../../core/widgets/ui_elements/status_modal_bottom_sheet.dart';
import 'status_viewmodel.dart';

class StatusPage extends StatelessWidget {
  // build personal status listile
  Widget _buildPersonalStatus(BuildContext context, StatusViewModel model) {
    final leading = _getStatusLeading(context, model);
    return ListTile(
      leading: leading,
      title: const Text('My status'),
      subtitle: Text(model.userStatus ?? 'Tap to add status update'),
      onTap: () {
        // show status modal bottom sheet
        showStatusModalBottomSheet(context);
      },
    );
  }

  // build users status widget
  Widget _buildStatus(
      Status status, BuildContext context, StatusViewModel model) {
    final timeAgo = formatDateTime(status.timestamp);
    final allowDelete = model.allowDelete(status.userName);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(status.profileUrl),
        backgroundColor: Colors.grey,
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
      onTap: allowDelete ? () => model.handleDeleteStatus(status) : null,
    );
  }

  // build divider text widget
  Widget _buildDividerText() {
    return Container(
        padding: const EdgeInsets.fromLTRB(15, 6, 0, 6),
        alignment: Alignment.centerLeft,
        child: const Text('Recent updates'));
  }

  // build users status widgets from firestore collection snapthots
  Widget _buildUsersStatus(BuildContext context, StatusViewModel model) {
    return StreamBuilder<QuerySnapshot>(
      stream: model.statusStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Expanded(
            child: Scrollbar(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              final status = Status.fromJsonMap(
                  snapshot.data.docs[index].data(),
                  snapshot.data.docs[index].id);
              return _buildStatus(status, context, model);
            },
          ),
        ));
      },
    );
  }

  // handle personal status leading widget
  Widget _getStatusLeading(BuildContext context, StatusViewModel model) {
    final _isLight = Theme.of(context).brightness == Brightness.light;
    return model.downloadUrl == null
        ? CircleAvatar(
            backgroundColor:
                _isLight ? Theme.of(context).primaryColor : Colors.blue,
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(model.downloadUrl),
            backgroundColor:
                _isLight ? Theme.of(context).primaryColor : Colors.blue,
          );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StatusViewModel>.reactive(
      viewModelBuilder: () => StatusViewModel(),
      onModelReady: (model) => model.initalise(),
      builder: (context, model, child) {
        return Scaffold(
            body: Column(
          children: [
            _buildPersonalStatus(context, model),
            _buildDividerText(),
            _buildUsersStatus(context, model)
          ],
        ));
      },
    );
  }
}
