import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'loading_viewmodel.dart';

import '../../../core/shared/constants.dart';

import '../../../core/widgets/ui_elements/spinkit_loading_indicator.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  bool _isLight;

  // build whatsapp image asset
  Widget _buildWhatsAppImage() {
    return Expanded(
        flex: 5,
        child: Image.asset(
          iconAssetName,
          fit: BoxFit.contain,
          height: 100,
          width: 100,
        ));
  }

  // build 'from facebook' text
  Widget _buildBottomText() {
    return Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'from',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.0),
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(colors: [Colors.amber, Colors.red])
                    .createShader(rect);
              },
              child: Text(
                'FACEBOOK',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    _isLight = Theme.of(context).brightness == Brightness.light;
    return ViewModelBuilder<LoadingViewModel>.nonReactive(
        viewModelBuilder: () => LoadingViewModel(),
        onModelReady: (model) => model.initalise(),
        builder: (context, model, child) {
          return SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: _isLight ? Colors.white : Colors.grey[900],
              body: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _buildWhatsAppImage(),
                      Expanded(flex: 1, child: SpinkitLoadingIndicator()),
                      _buildBottomText()
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
