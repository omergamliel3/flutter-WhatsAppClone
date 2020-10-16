import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'calls_viewmodel.dart';

import 'package:call_log/call_log.dart';

class CallsPage extends StatelessWidget {
  // call log list tile widget
  Widget _buildCallsListTile(CallLogEntry callLogEntry, CallsViewModel model) {
    final name = callLogEntry.name[0] ?? 'Unknown';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          name.toUpperCase(),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(callLogEntry.name ?? 'Unknown'),
      subtitle: Text(callLogEntry.formattedNumber ?? 'Unknown'),
      trailing: const Icon(Icons.call),
      onTap: () {
        // launch device phone call
        model.launchCall(callLogEntry.number);
      },
    );
  }

  // build empty call logs widget text
  Widget _buildEmptyCallLogs(BuildContext context, CallsViewModel model) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: Text(
          'THERE ARE NO CALL LOGS',
          style: Theme.of(context).textTheme.headline6,
        ));
  }

  // build call logs listview
  Widget _buildCallLogsListView(
      List<CallLogEntry> callLogsData, CallsViewModel model) {
    return Scrollbar(
      child: ListView.builder(
          physics: const ScrollPhysics(),
          itemCount: callLogsData.length,
          itemBuilder: (context, index) {
            return _buildCallsListTile(callLogsData[index], model);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CallsViewModel>.nonReactive(
        viewModelBuilder: () => CallsViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              body: FutureBuilder<Iterable<CallLogEntry>>(
            future: model.getCallLogs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final callLogsData = snapshot.data.toList();
                if (callLogsData.isEmpty) {
                  return _buildEmptyCallLogs(context, model);
                }
                return _buildCallLogsListView(callLogsData, model);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ));
        });
  }
}
