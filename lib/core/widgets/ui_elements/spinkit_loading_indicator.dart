import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../shared/constants.dart';

class SpinkitLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return SpinKitFadingCircle(
      itemBuilder: (context, index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isLight
                ? kAccentColor
                : index.isEven ? kPrimaryColor : kAccentColor,
          ),
        );
      },
    );
  }
}
