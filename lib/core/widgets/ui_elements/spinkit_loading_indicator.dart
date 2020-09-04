import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/shared/constants.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinkitLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? kPrimaryColor : kAccentColor,
          ),
        );
      },
    );
  }
}
