import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Text('CAMERA PAGE'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
