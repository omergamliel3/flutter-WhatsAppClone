import 'package:flutter/material.dart';

import '../../models/status.dart';

import '../../../locator.dart';
import '../../../services/auth/user_service.dart';
import '../../../services/firebase/analytics_service.dart';

import 'package:fluttertoast/fluttertoast.dart';
import '../../alerts/toast.dart';

import 'spinkit_loading_indicator.dart';

// parent container border radius
const borderRadius = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)));

// inner child container border radius
const borderRadiusGeometry = BorderRadius.only(
    topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0));

// evoke modal bottom sheet
void showStatusModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: borderRadius,
      builder: (context) {
        return ModalBottomSheetScreen();
      });
}

class ModalBottomSheetScreen extends StatefulWidget {
  @override
  _ModalBottomSheetScreenState createState() => _ModalBottomSheetScreenState();
}

class _ModalBottomSheetScreenState extends State<ModalBottomSheetScreen> {
  // text field controller
  final TextEditingController _textEditingController = TextEditingController();
  // responsive widget
  Widget _responsiveWidget;
  // get services
  final userService = locator<UserService>();

  @override
  void initState() {
    _responsiveWidget = _buildUploadButton();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // build status text field
  Widget _buildTextField(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: isLight ? Colors.grey[300] : Colors.grey[600],
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: _textEditingController,
        keyboardType: TextInputType.text,
        autofocus: true,
        decoration:
            const InputDecoration.collapsed(hintText: 'Enter your status'),
      ),
    );
  }

  // build upload status button
  Widget _buildUploadButton() {
    return FlatButton(
      onPressed: () {
        _updateStatus();
      },
      child: const Text(
        'UPLOAD STATUS',
      ),
    );
  }

  // update status in FirestoreService, PrefsService, MainModel provider
  Future _updateStatus() async {
    if (_textEditingController.value.text == null ||
        _textEditingController.value.text.isEmpty) return;
    final url = await userService.getProfilePicURL();
    final status = Status(
        userName: userService.userName,
        profileUrl: url,
        content: _textEditingController.value.text,
        timestamp: DateTime.now().toUtc());

    setState(() {
      _responsiveWidget = Center(
        child: SpinkitLoadingIndicator(),
      );
    });

    // upload status to firestore db
    final upload = await userService.uploadStatus(status);
    if (upload) {
      locator<AnalyticsService>().logStatusEvent(status.content.length);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else {
      // show toast allert
      showToast('Unable to upload status', Toast.LENGTH_SHORT);
      // reset flag and setState to update responsive widget back to button
      setState(() {
        _responsiveWidget = _buildUploadButton();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // execute this code one time only
    final targetSize = MediaQuery.of(context).size.height * 0.2;
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(borderRadius: borderRadiusGeometry),
        child: Container(
          height: targetSize,
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(context),
              const SizedBox(
                height: 10,
              ),
              _responsiveWidget
            ],
          ),
        ),
      ),
    );
  }
}
