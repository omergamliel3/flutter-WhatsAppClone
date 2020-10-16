import 'dart:io';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'display_picture_viewmodel.dart';

class DisplayPictureView extends StatelessWidget {
  final String imagePath;
  const DisplayPictureView({Key key, this.imagePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewModelBuilder<DisplayPictureViewModel>.nonReactive(
        viewModelBuilder: () => DisplayPictureViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(),
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => model.sendPicture(imagePath),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
