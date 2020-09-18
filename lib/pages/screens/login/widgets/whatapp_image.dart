import 'package:flutter/material.dart';

import '../../../../core/shared/constants.dart';

class WhatsAppImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Image.asset(
        iconAssetName,
        fit: BoxFit.contain,
        height: 100,
        width: 100,
      ),
    );
  }
}
