import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'camera_viewmodel.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CameraViewModel>.nonReactive(
      viewModelBuilder: () => CameraViewModel(),
      builder: (context, model, child) => Center(
        child: Text('CAMERA PAGE'),
      ),
    );
  }
}
