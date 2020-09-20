import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'camera_viewmodel.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<CameraViewModel>.nonReactive(
      viewModelBuilder: () => CameraViewModel(),
      builder: (context, model, child) => Center(
        child: Text('CAMERA PAGE'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
