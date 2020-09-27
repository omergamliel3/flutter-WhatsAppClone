import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'calls_viewmodel.dart';

import 'package:call_log/call_log.dart';

class CallsPage extends StatefulWidget {
  @override
  _CallsPageState createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage>
    with AutomaticKeepAliveClientMixin {
  // view model reference
  CallsViewModel _model;
  // call log list tile widget
  Widget _buildCallsListTile(CallLogEntry callLogEntry) {
    var name = callLogEntry.name[0] ?? 'Unknown';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          name.toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(callLogEntry.name ?? 'Unknown'),
      subtitle: Text(callLogEntry.formattedNumber ?? 'Unknown'),
      trailing: Icon(Icons.call),
      onTap: () {
        // launch device phone call
        _model.launchCall(callLogEntry.number);
      },
    );
  }

  // build empty call logs widget text
  Widget _buildEmptyCallLogs() {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: Text(
          'THERE ARE NO CALL LOGS',
          style: Theme.of(context).textTheme.headline6,
        ));
  }

  // build call logs listview
  Widget _buildCallLogsListView(List<CallLogEntry> callLogsData) {
    return Scrollbar(
      child: ListView.builder(
          physics: ScrollPhysics(),
          itemCount: callLogsData.length,
          itemBuilder: (context, index) {
            return _buildCallsListTile(callLogsData[index]);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<CallsViewModel>.nonReactive(
        viewModelBuilder: () => CallsViewModel(),
        builder: (context, model, child) {
          // global class reference to the model
          _model = model;
          return Scaffold(
              body: FutureBuilder<Iterable<CallLogEntry>>(
            future: model.getCallLogs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var callLogsData = snapshot.data.toList();
                if (callLogsData.length == 0) {
                  return _buildEmptyCallLogs();
                }
                return _buildCallLogsListView(callLogsData);
              }
              return Center(child: CircularProgressIndicator());
            },
          ));
        });
  }

  @override
  bool get wantKeepAlive => true;
}
