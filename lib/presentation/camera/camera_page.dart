import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:stacked/stacked.dart';

import 'camera_viewmodel.dart';

import '../../core/widgets/ui_elements/spinkit_loading_indicator.dart';

class CameraPage extends StatelessWidget {
  Widget _buildView(CameraViewModel model) {
    return Column(
      children: [
        Expanded(flex: 4, child: CameraPreview(model.cameraController)),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () => model.switchCamera(),
              child: const Icon(
                Icons.switch_camera,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            MaterialButton(
              onPressed: () => model.takePicture(),
              child: const Icon(
                Icons.camera_alt,
                size: 30,
              ),
            )
          ],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CameraViewModel>.reactive(
      viewModelBuilder: () => CameraViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: FutureBuilder<void>(
          future: model.initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return _buildView(model);
            }
            // Otherwise, display a loading indicator.
            return Center(
              child: SpinkitLoadingIndicator(),
            );
          },
        ),
      ),
    );
  }
}
